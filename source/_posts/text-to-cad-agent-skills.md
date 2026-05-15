---
title: 这可能是 AI Agent 的下一个硬核入口：一句话生成 CAD、机器人模型和工程文件
date: 2026-05-15 12:04:58
description: "text-to-cad 把 CAD、机器人描述和硬件设计流程包装成 Agent Skills：先写可追溯源码，再导出 STEP/STL/URDF 等工程文件。"
categories:
- AI
tags:
- AI Agent
- CAD
- 机器人
- 开源项目
---

> text-to-cad 把 CAD、机器人描述和硬件设计流程包装成 Agent Skills：先写可追溯源码，再导出 STEP/STL/URDF 等工程文件。

![文章封面](/images/wechat-sync/text-to-cad-agent-skills/cover.jpg)

最近看到一个很有意思的开源项目：earthtojake/text-to-cad。名字听起来像“文本转 CAD”，但它真正做的事情更像是给 Codex、Claude Code、Gemini CLI、OpenClaw 这类 Coding Agent 装上一套硬件工程技能包。

项目地址：https://github.com/earthtojake/text-to-cad

它的定位很明确：A collection of agent skills for CAD, robotics and hardware design。也就是说，它不是只想生成一张好看的 3D 图，而是希望 Agent 能参与更真实的 CAD、机器人和硬件设计工作流。

## 一、它解决的不是“画出来”，而是“做成工程文件”

很多 Text-to-3D 项目停在视觉层面：输入一句话，得到一个模型预览。但工程世界更关心的是：

- 能不能导出 STEP / STL / 3MF / DXF 这样的可交付文件；
- 能不能保留可修改、可复现的源代码；
- 能不能检查几何、引用具体面和边，方便下一轮修改；
- 能不能和机器人描述文件 URDF / SDF / SRDF 串起来；
- 能不能找现成标准件，而不是每次从零瞎编一个螺丝。

text-to-cad 的 README 里列出的能力，正是围绕这些工程化需求展开：Generate、Export、Browse、Source、Reference、Review、Reproduce、Local。

这几个词放在一起，说明作者不是在做一个炫技 Demo，而是在把“AI 生成 CAD”拆成 Agent 可以稳定执行的步骤。

## 二、核心思路：让 Agent 写 CAD 源码，再导出明确目标

这个项目的 CAD Skill 以 build123d / Python 为基础，默认把 STEP 当作一等公民。Agent 不是直接吐一个神秘的二进制模型，而是先生成或修改参数化 CAD 源码，再导出 STEP、STL、3MF、DXF、GLB/topology 等目标文件。

这点非常关键。

如果 AI 只是生成最终模型，后续修改会很痛苦：今天说“孔距加 2mm”，明天说“把倒角改小一点”，模型本身没有清晰的设计意图，Agent 很容易越改越乱。

但如果它维护的是源代码，工程师就能看到尺寸、基准、孔、倒角、装配关系是如何定义的。下一轮修改也可以落在源码层，而不是对网格做玄学手术。

## 三、它不只管零件，还覆盖机器人描述

text-to-cad 里比较有价值的一点，是它把 CAD 和机器人文件放在同一个技能体系里：

- CAD Skill：生成 STEP、STL、3MF、DXF、GLB/topology，并提供几何引用；
- CAD Explorer Skill：本地预览 CAD 和机器人描述文件；
- step.parts Skill：搜索、评估、下载常见标准件 STEP 模型；
- URDF Skill：生成和校验 ROS 常用机器人描述；
- SDF Skill：面向仿真场景的 SDFormat / SDF；
- SRDF Skill：面向 MoveIt2 的语义机器人描述；
- SendCutSend Skill：面向 SendCutSend 下单前的 DXF / STEP 预检查。

这说明它瞄准的是“硬件 Agent 工作台”，而不是单点 CAD 生成器。一个 Agent 未来可能从自然语言需求出发，生成结构件、拉标准件、输出机器人描述、打开预览、做下单前检查，形成完整闭环。

## 四、CAD Explorer 让迭代更像真实协作

项目提供了 CAD Explorer，用来检查生成的几何、钣金展开和机器人描述文件。README 里还提到一个很重要的能力：复制稳定的 @cad[...] 引用，让 Agent 能基于具体几何位置做后续编辑。

这非常像把“看图说话”变成“指着模型说话”。

传统对话里，我们只能说“把左边那个孔往上挪一点”。但在 CAD 场景里，“左边那个孔”必须变成可定位、可复现的对象引用。否则 Agent 下一轮很可能理解错对象。

@cad[...] 这类引用的价值就在这里：让人、Agent、模型预览之间有一个共同坐标系。

## 五、为什么这是 Agent 时代很重要的方向

软件 Agent 已经可以改代码、跑测试、提 PR。但硬件设计更难，因为它有几个天然门槛：

1. 几何约束比文字更严格。尺寸、装配、坐标系错一点，结果就不可用。
2. 输出格式更复杂。STEP、URDF、SDF、SRDF、DXF 各自服务不同环节。
3. 迭代成本更高。一个错误可能到打印、加工、装配时才暴露。
4. 标准件和供应链很重要。真实项目不会把所有零件都从零生成。

text-to-cad 的路线不是让 AI “凭感觉画一个”，而是给 Agent 加上技能、约束、验证和预览。它承认硬件设计不能只靠一次性生成，必须有可审计的过程。

## 六、目前应该怎么看它

这个项目创建于 2026 年 4 月，目前 GitHub 上已经有 2.7k+ stars、300+ forks，采用 MIT License。它的 README 显示支持 Codex、Claude Code、Gemini CLI、OpenClaw，也可以通过 npx agent-skills-cli 安装。

但我更建议把它看成一个方向，而不是“马上替代工程师”的成品。

对于真实机械设计，AI 仍然需要工程师定义需求、检查约束、确认材料和工艺，尤其涉及承重、安全、加工公差、运动学和仿真时，不能把 Agent 输出当最终结论。

它最适合的切入点，可能是这些：

- 快速生成早期结构草案；
- 把自然语言需求转成参数化 CAD 初稿；
- 生成标准格式文件，方便预览和讨论；
- 拉取标准件，减少重复建模；
- 给机器人项目生成 URDF / SDF / SRDF 初版；
- 在下单或加工前做基础预检查。

## 七、真正值得关注的是“技能化”

我觉得 text-to-cad 最有启发的地方，不只是 CAD，而是它用“Agent Skills”的方式包装硬件能力。

过去我们习惯给 AI 一个大 Prompt，让它临场发挥。现在更有效的方式可能是：把某个专业领域的流程、默认假设、验证步骤、工具调用和输出约束，沉淀成可复用 Skill。

CAD、机器人、硬件设计都非常适合这种模式。因为这些领域不仅需要生成内容，还需要遵守流程。

如果未来 Agent 能可靠调用这类技能，那么“自然语言 → 源码 → 工程文件 → 可视化检查 → 修改 → 交付”的链路，会比单纯 Text-to-3D 更接近真实生产力。

## 结语

earthtojake/text-to-cad 让我看到一个很清晰的趋势：AI Agent 正在从“帮你写字、写代码”，进入“帮你生成可交付工程资产”的阶段。

它还不是魔法按钮，但方向对了：不是把 CAD 当图片生成，而是把硬件设计拆成可执行、可验证、可复现的工作流。

这可能就是 Agent 进入物理世界的一条现实路径。

---

更多内容欢迎关注公众号：

![公众号关注二维码](https://zmgo.oss-cn-shenzhen.aliyuncs.com/logo/qrcode_for_gh_de689d92e7f2_258.jpg)
