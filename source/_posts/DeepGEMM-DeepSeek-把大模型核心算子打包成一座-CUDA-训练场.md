---
title: "DeepGEMM：DeepSeek 把大模型核心算子打包成一座 CUDA 训练场"
date: 2026-04-23 10:00:00
categories: [AI, 公众号]
tags: [AI, 公众号同步]
description: "DeepGEMM 不只是一个 GEMM 库，它把 FP8/FP4/BF16、MoE、MQA、JIT 与新一代 NVIDIA 架构经验收敛到一个更轻、更可读的 CUDA 工程里。"
cover: "https://mmbiz.qpic.cn/mmbiz_jpg/81QgEribibGVT88mokte9MKgJQzqRnBvPOCkbHOMricwhqtIvAkicTzUwMBDpZPP8iaeCyhXKSw3gDAL8ibwKEwD0FogV011ANX74QnT3eWMICHS4/0?wx_fmt=jpeg"
wechat_link: "https://mp.weixin.qq.com/s/iihmy8okg9TMKpLdGSowMw"
wechat_aid: "2247484080_1"
---

一、为什么这个项目值得看

DeepGEMM 是 DeepSeek 开源的高性能 Tensor Core Kernel Library。项目自述里给它的定位很明确：把现代大语言模型里的关键计算原语，统一放到一个 CUDA 代码库中，包括 FP8、FP4、BF16 GEMM，带通信重叠的 fused MoE（Mega MoE），用于 lightning indexer 的 MQA scoring，HyperConnection 等。

这类项目的价值不只在“又快了一点”。对模型训练和推理系统来说，GEMM 早已不是一个孤立函数，而是量化格式、显存布局、专家并行、通信调度、JIT 编译、硬件代际差异共同作用的结果。DeepGEMM 把这些细节暴露得足够集中，因此它更像一份面向 LLM 系统工程的 CUDA 样本。

二、它解决的不是单个矩阵乘法

传统理解里，GEMM 就是 D = C + A @ B。但在大模型场景里，真实问题会复杂很多：

- FP8 / FP4 量化需要 scaling factor，并且 scaling factor 本身也有布局要求；
- MoE 里每个专家收到的 token 数不同，需要 grouped GEMM，而不是标准 dense GEMM；
- 推理解码阶段常配合 CUDA Graph，CPU 可能并不知道每个专家的实时 token 数，于是需要 masked grouped GEMM；
- 新模型结构还会引入 MQA scoring、HyperConnection、SwiGLU 等更贴近模型结构的融合算子。

DeepGEMM 的接口正是围绕这些场景展开：普通 dense GEMM、M 轴 grouped GEMM、K 轴 grouped GEMM、masked grouped GEMM、FP8/FP4 MQA logits、Mega MoE，以及若干布局转换工具。它不是把 cuBLAS 再包装一层，而是把 LLM 里的“非标准但高频”的路径做成一组专用 kernel。

三、最有意思的设计：运行时 JIT

DeepGEMM 安装时不要求直接编译所有 CUDA kernel。项目通过轻量级 JIT 模块，在运行时根据形状、架构和配置生成并编译 kernel。代码里可以看到，它会把 kernel 名称、编译器签名、flags 和源码拼成签名，再落到 ~/.deep_gemm/cache 下；并采用“先编译到临时目录，再原子 rename”的方式，避免分布式文件系统里多进程同时写缓存导致的脏状态。

这个设计有两个好处。

1. 安装路径更轻。用户安装 Python 包时不用提前承受完整 CUDA 编译成本。
2. 调优空间更细。不同 shape、不同架构、不同布局可以走不同 kernel 生成路径，不必把所有分支塞进一个巨大模板实例里。

项目也保留了 NVCC 与 NVRTC 两种编译路径。README 里提到 NVRTC 曾带来最高 10x 的编译加速，但当前主线又强调 NVCC 12.9 对性能更友好。这说明 DeepGEMM 的目标不是只追求“编得快”，而是在编译速度、最终 SASS 质量与工程可控性之间权衡。

四、SM90 与 SM100：硬件变化进入 API 层

DeepGEMM 明确面向 NVIDIA SM90 或 SM100 架构。README 对 CUDA 版本也写得很直接：SM90 需要 CUDA 12.3+，强烈建议 12.9+；SM100 需要 CUDA 12.9+。

更关键的是，SM90 和 SM100 的数据要求不同。例如 scaling factor：SM90 使用 FP32；SM100 使用 packed UE8M0，把 4 个 UE8M0 打包到一个 torch.int 中。接口层并没有假装这些差异不存在，而是通过布局转换工具和架构分派来处理。

这也是项目的学习价值所在：高性能 kernel 并不是写一段数学等价代码就结束，而是要理解硬件支持的数据格式、TMA 对齐、swizzle、shared memory 容量、cluster multicast、tensor memory 等约束。DeepGEMM 的 heuristics 代码里能看到大量候选 block size、stage 数、swizzle 模式与 cluster 约束的筛选逻辑。

五、Mega MoE：把通信和计算合到同一个视角

2026 年 4 月 16 日的公开版本引入了 Mega MoE、FP8xFP4 GEMM、FP4 Indexer、PDL、更快的 JIT 编译等特性。其中最值得关注的是 Mega MoE。

MoE 的瓶颈经常不只是专家内的矩阵乘法，还包括 expert parallel 里的 dispatch 和 combine。DeepGEMM 的 Mega MoE 把 EP dispatch、linear 1（FP8xFP4）、SwiGLU、linear 2（FP8xFP4）和 EP combine 融合进一个 mega-kernel，并尝试重叠 NVLink 通信与 Tensor Core 计算。

从测试代码看，Mega MoE 依赖 PyTorch symmetric memory，并以多进程方式运行。调用前需要准备 symmetric buffer，把 FP8 输入、scaling factor、top-k expert index 和权重拷进去，再调用 fp8_fp4_mega_moe。它的目标不是替换一个单独 GEMM，而是把 MoE 前向路径上的多段操作压缩成更少的调度边界。

六、性能口径：不要只看峰值 TFLOPS

README 提到 DeepGEMM 在 H800 上最高达到 1550 TFLOPS，也强调性能可匹配或超过专家调优库。但读这个项目时，更建议把它当成“性能方法论”来看，而不是只记一个峰值数字。

它的性能来源大致包括：

- 面向 FP8/FP4/BF16 的专用 MMA 路径；
- 针对 grouped / masked grouped 形状做调度；
- 对 scaling factor 布局进行 TMA 友好化；
- 通过 JIT 为实际 shape 选择 block、cluster、stage 与 swizzle；
- 在 MoE 场景把通信和计算作为一个整体优化。

这也意味着它并不是通用替代品。输入转置、FP8 casting 等操作仍需用户在前置 kernel 中处理或融合；项目里的工具函数能帮忙，但主线重点仍然是优化 GEMM 与模型专用 kernel 本身。

七、谁最应该研究 DeepGEMM

1. 做 LLM 推理和训练系统的人：它展示了 MoE、低精度、JIT、通信重叠如何在一个工程里组合。
2. 学 CUDA 优化的人：相比重模板化项目，DeepGEMM 的代码结构相对克制，README 也强调“simplicity”。
3. 做模型架构落地的人：项目把 MQA、HyperConnection、SwiGLU 等模型结构和 kernel 设计放在一起看。
4. 维护 GPU 基础设施的人：JIT cache、多进程编译、分布式文件系统一致性这些细节非常实战。

八、一个判断

DeepGEMM 的意义在于，它把“模型创新之后的系统账”摊开了：当大模型进入 FP8/FP4、MoE、长上下文检索、专家并行之后，性能优化不再是调用一个标准库函数，而是把数据格式、布局、编译、通信和硬件代际放进同一个设计面。

所以，研究 DeepGEMM 不只是研究 DeepSeek 写了哪些 kernel，更是在研究下一代 LLM 系统库应该长什么样：更专用、更动态、更贴近模型结构，也更贴近硬件真实边界。

项目地址：https://github.com/deepseek-ai/DeepGEMM

---

更多内容欢迎关注公众号：

![公众号关注二维码](https://zmgo.oss-cn-shenzhen.aliyuncs.com/logo/qrcode_for_gh_de689d92e7f2_258.jpg)
