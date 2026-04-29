---
title: LTX-2.3：音画一体视频模型，本地部署要什么配置？
date: 2026-04-29 17:05:34
description: "LTX-2.3 是 Lightricks 对 LTX-2 的重要升级：用一个 DiT 音画基础模型同时生成视频与同步音频，并开放 22B 权重、蒸馏版与时空超分组件。本文梳理它的能力边界和本地部署配置。"
categories:
- AI
tags:
- LTX-2.3
- 视频生成
- 音画生成
- 本地部署
- 开源模型
---

> LTX-2.3 是 Lightricks 对 LTX-2 的重要升级：用一个 DiT 音画基础模型同时生成视频与同步音频，并开放 22B 权重、蒸馏版与时空超分组件。本文梳理它的能力边界和本地部署配置。

![LTX-2.3 音画一体视频模型封面](https://cdn.pearktrue.cn/apiservers/cache/images/2026-04-29/d1e138f6-225a-494e-826d-44ee96e3aeaf.png)

## 一、LTX-2.3 到底是什么

LTX-2.3 是 Lightricks 发布的开源音画一体基础模型，也是 LTX-2 系列的一次重要升级。和只生成画面的文生视频模型不同，它的核心目标是：在同一个扩散模型里生成视频和声音，让画面动作、环境声、语音节奏更容易在时间线上对齐。

官方模型卡把它定义为一个 DiT-based audio-video foundation model。简单说，它不是“先生成视频、再给视频配音”的后处理流水线，而是把音频和视频作为同一代际任务来建模。这一点决定了它更适合做带声画关系的短片、广告分镜、音乐/动作片段、角色表演和多模态视频实验。

## 二、这次 2.3 版本主要升级了什么

相比 LTX-2，LTX-2.3 的重点不在“多一个文生视频模型”，而在三个方向：

- 音频质量和视觉质量进一步提升，尤其是官方提到 v1.1 蒸馏版相比 v1.0 有不同的审美体验和更好的音频表现。
- Prompt adherence 更强，复杂提示词、镜头意图和声画描述的执行更稳定。
- 开放组件更完整，不只给一个大模型权重，还给了蒸馏版、蒸馏 LoRA、空间超分、时间超分等模块，方便研究者和创作者做多阶段工作流。

官方目前列出的核心权重包括：

- ltx-2.3-22b-dev：完整 22B 模型，bf16，灵活且可训练。
- ltx-2.3-22b-distilled / distilled-1.1：蒸馏版本，典型配置为 8 steps、CFG=1，适合更快推理。
- ltx-2.3-22b-distilled-lora-384 / 1.1：可叠加到完整模型上的蒸馏 LoRA。
- ltx-2.3-spatial-upscaler-x2 / x1.5：面向更高分辨率的空间超分模块。
- ltx-2.3-temporal-upscaler-x2：面向更高 FPS 的时间超分模块。

## 三、它适合谁使用

如果只想快速生成几秒无声视频，LTX-2.3 未必是成本最低的选择。它更适合下面几类用户：

- 做 AI 影视、广告分镜、音乐视觉化，需要画面和音频同步的人。
- 做开源视频模型研究，需要可训练、可组合、可本地运行的 22B 音画模型的人。
- 做 ComfyUI 或 PyTorch 工作流，希望把文生视频、图生视频、视频重绘、关键帧插值、音频驱动视频放进同一套工具链的人。
- 想在本地实验 LoRA、IC-LoRA、风格/动作/角色一致性训练的人。

它的价值更像“开放的音画生成底座”，而不是一个单纯的在线生视频按钮。

## 四、本地部署有两条路

### 1. ComfyUI 路线

对创作者最友好的方式，是使用 ComfyUI Manager 里的 LTXVideo 节点。优点是可视化、好接插件、容易和图像参考、视频后处理、上采样节点组合。缺点是版本依赖和显存管理需要耐心调试。

### 2. PyTorch / 官方代码路线

官方 LTX-2 代码库是一个 monorepo，包含 ltx-core、ltx-pipelines、ltx-trainer 等包。官方模型卡写明，代码库测试环境为 Python >= 3.12、CUDA > 12.7，并支持 PyTorch ~= 2.7。

典型安装流程是：

```bash
git clone https://github.com/Lightricks/LTX-2.git
cd LTX-2
uv sync
source .venv/bin/activate
```

推理则通过 ltx-pipelines 包选择不同管线，例如两阶段 text/image-to-video、distilled 快速管线、video-to-video、keyframe interpolation、audio-to-video、retake 等。

## 五、本地部署的设备配置要求

先给结论：LTX-2.3 不是轻量模型。它的 22B 规模和音画联合生成特性，决定了本地运行更接近“工作站/GPU 服务器任务”，而不是普通消费级笔记本任务。

官方文档给出的最低配置是：

| 项目 | 最低要求 |
|---|---|
| GPU | NVIDIA GPU，至少 32GB+ VRAM，显存越大越好 |
| 系统内存 | 32GB RAM |
| 存储 | 100GB 可用空间 |
| CUDA | 11.8 或更高 |
| Python | 3.10 或更高 |

官方推荐配置是：

| 项目 | 推荐配置 |
|---|---|
| GPU | NVIDIA A100 80GB 或 H100 |
| 系统内存 | 64GB+ RAM |
| 存储 | 200GB+ SSD |
| CUDA | 12.1 或更高 |

如果采用官方 PyTorch 代码库，还要注意模型卡里的测试环境：Python >= 3.12、CUDA > 12.7、PyTorch ~= 2.7。也就是说，文档最低要求可以作为“能否尝试”的门槛，而官方代码的测试组合更适合作为“少踩坑”的参考。

## 六、不同设备该怎么预期

### 1. 24GB 显存：不建议作为主力

RTX 4090、RTX 3090 等 24GB 卡很强，但对 LTX-2.3 的完整 22B 本地推理来说显存偏紧。可以关注社区是否出现 FP8、量化、CPU offload、低分辨率或蒸馏管线优化，但不要把它当成官方最低体验。

### 2. 32GB 到 48GB 显存：可以尝试，建议从蒸馏版开始

这一区间更接近官方最低门槛。建议优先试 distilled-1.1 或更轻的管线，降低分辨率和帧数，先确认环境、权重、节点/脚本都能跑通，再逐步提高输出规格。

### 3. 80GB 显存：更接近生产体验

A100 80GB 或 H100 是官方推荐配置，适合完整模型、多阶段管线、空间/时间超分、较高分辨率和更稳定的批量实验。如果要做团队内部工具或内容生产，建议按这个级别规划预算。

## 七、部署时最容易忽略的几个细节

第一，分辨率和帧数不是随便填。官方提示 width 和 height 必须能被 32 整除；frame count 必须满足“8 的倍数 + 1”。不满足时需要 padding，再裁回目标尺寸和帧数。

第二，权重不只一个文件。两阶段管线通常还会涉及主模型、蒸馏 LoRA、空间超分器、Gemma 文本编码器等组件。部署前要把模型目录规划好，不要只下载一个 safetensors 就开始排错。

第三，SSD 空间要留足。官方最低写 100GB，推荐 200GB+ SSD。考虑到多个权重、缓存、输出视频、ComfyUI 插件和 Python 环境，实际项目机器最好按更高余量准备。

第四，先跑最小样例，再追求画质。建议从短时长、低分辨率、蒸馏模型开始，确认驱动、CUDA、PyTorch、节点、权重路径都正常，然后再打开两阶段、高质量采样、空间超分或时间超分。

## 八、一个务实的本地部署建议

如果你只是想体验 LTX-2.3，优先使用在线 Playground 或 ComfyUI 节点；如果你想在本地认真研究，建议至少准备 32GB 显存 NVIDIA GPU、32GB 系统内存和 100GB SSD；如果你想稳定做内容生产，则按 80GB 显存、64GB+ 内存、200GB+ SSD 来规划。

真正值得关注的是：LTX-2.3 把开源视频模型从“只管画面”进一步推向“音画共同生成”。这会让本地 AI 视频工作流不再只是补帧、换脸、上采样，而是开始触及短片制作里最难的部分：节奏、声音、动作和镜头的一体化控制。

参考资料：
- LTX-2.3 Hugging Face Model Card：https://huggingface.co/Lightricks/LTX-2.3
- LTX-2 GitHub：https://github.com/Lightricks/LTX-2
- LTX System Requirements：https://docs.ltx.video/open-source-model/getting-started/system-requirements

---

更多内容欢迎关注公众号：

![公众号关注二维码](https://zmgo.oss-cn-shenzhen.aliyuncs.com/logo/qrcode_for_gh_de689d92e7f2_258.jpg)
