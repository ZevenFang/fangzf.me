---
title: AI 做视频终于不用剪辑软件了？HeyGen 开源 Hyperframes：写 HTML 就能生成 MP4
date: 2026-05-13 14:08:48
description: "HeyGen 开源 Hyperframes，把 HTML/CSS/JS 变成可预览、可渲染、可自动化的视频生成流水线，让 AI 智能体可以写 HTML 导出 MP4。"
categories:
- AI
tags:
- Hyperframes
- AI Agent
- 视频生成
- 开源项目
---

> Hyperframes 是 HeyGen 开源的 HTML 原生视频渲染框架：写 HTML、预览视频、导出 MP4，并且从设计上面向 AI 智能体自动化创作。

![文章封面](/images/wechat-sync/hyperframes-html-video-agent/cover.png)

如果说过去两年 AI 智能体最擅长的是“写文字、写代码、调工具”，那么视频创作一直是一个相对难啃的场景。

原因很简单：视频不是一段文本，它有时间轴、画面层级、音频、字幕、转场、动画、素材管理和最终编码。传统视频编辑器适合人用鼠标操作，但不适合智能体稳定调用；很多代码化视频方案又要求写特定框架，学习成本和生成成本都不低。

最近 HeyGen 开源了一个很有意思的项目：Hyperframes。

项目地址：https://github.com/heygen-com/hyperframes

它的口号很直接：Write HTML. Render video. Built for agents.

翻译过来就是：写 HTML，渲染视频，为智能体而生。

## 一、Hyperframes 是什么？

Hyperframes 是一个开源的视频渲染框架，它允许开发者用 HTML 来描述视频画面和时间轴，然后预览并渲染成 MP4。

它不是传统意义上的剪辑软件，也不是又一个复杂的可视化编辑器。它更像是把网页开发里最熟悉的 HTML、CSS、JavaScript、动画库，变成一套可重复、可自动化的视频生成流水线。

一个最简单的 Hyperframes 视频，可以像这样定义：

```html
<div id="stage" data-composition-id="my-video" data-start="0" data-width="1920" data-height="1080">
  <video data-start="0" data-duration="5" data-track-index="0" src="intro.mp4" muted playsinline></video>
  <img data-start="2" data-duration="3" data-track-index="1" src="logo.png" />
  <audio data-start="0" data-duration="9" data-track-index="2" data-volume="0.5" src="music.wav"></audio>
</div>
```

也就是说，视频里的素材、开始时间、持续时长、层级关系，都可以用 HTML 标签和 data 属性描述。

## 二、为什么这个项目值得关注？

Hyperframes 最值得关注的点，不只是“HTML 能导出视频”，而是它把视频生成这件事设计成了 AI 智能体容易理解、容易执行、容易校验的工作流。

### 1. HTML 是大模型最熟悉的表达方式

大模型训练语料里有大量网页代码。相比让模型学习一套全新的视频 DSL，或者让它在复杂的 React 组件框架里处理时间轴，直接让它写 HTML、CSS 和常见动画代码，天然更接近模型的能力区。

这意味着智能体可以更自然地完成：

- 根据主题生成视频结构
- 写标题、字幕、卡片、图表和转场
- 调整配色、排版、动画节奏
- 修改某个元素的位置、时长和样式
- 在失败后根据报错继续修复

对智能体来说，HTML 是一种“可读、可写、可 diff、可重试”的格式。

### 2. 非交互式 CLI 更适合自动化

Hyperframes 提供 CLI，可以通过命令初始化、预览、检查和渲染项目：

```bash
npx hyperframes init my-video
cd my-video
npx hyperframes preview
npx hyperframes render
```

它的命令行默认面向自动化流程设计：参数化、非交互、失败即报错。这一点对智能体非常关键。

因为智能体最怕的是“卡在一个需要人点按钮的界面里”。只要命令可以稳定执行，智能体就能把视频生成纳入完整任务链：准备素材、生成 HTML、运行 lint、预览、渲染、检查输出文件，最后交付成品。

### 3. 确定性渲染，适合流水线

官方文档反复强调一个关键词：deterministic rendering，也就是确定性渲染。

Hyperframes 的渲染管线会按帧驱动浏览器，把每一帧捕获后交给 FFmpeg 编码。理想情况下，同样的输入会得到同样的输出。

这对自动化非常重要。因为一旦生成视频变成可复现的工程流程，它就可以进入 CI、批量生成、测试回归和内容生产流水线，而不是每次都靠人工拖时间轴。

## 三、它和 Remotion 有什么不同？

很多做代码化视频的人会想到 Remotion。Hyperframes 官方也明确提到，它受到 Remotion 启发，并且 HeyGen 曾在生产中使用过 Remotion。

两者的核心差异可以概括为一句话：Remotion 让你写 React，Hyperframes 让你写 HTML。

| 维度 | Hyperframes | Remotion |
| --- | --- | --- |
| 创作方式 | HTML + CSS + JS / GSAP | React / TSX 组件 |
| 构建步骤 | index.html 可直接播放 | 通常需要 bundler |
| 动画生态 | 更自然接入 GSAP、Lottie、Three.js 等浏览器生态 | 更依赖 React 组件化表达 |
| 智能体友好度 | 更贴近大模型常见训练语料 | 需要更多框架规则约束 |
| 当前分布式渲染 | 官方说明目前偏单机 | Remotion Lambda 更成熟 |
| 许可证 | Apache 2.0 | 源码可见但商业许可不同 |

这并不是说 Hyperframes 一定全面替代 Remotion。Remotion 在 React 生态、类型系统、成熟度和分布式渲染上仍然有明显优势。

但 Hyperframes 的选择很清晰：如果目标是让 AI 智能体更自然地生成视频，让网页、设计稿、动效代码更低成本地变成视频，那么 HTML-first 的路线很有吸引力。

## 四、Hyperframes 的架构拆解

从仓库结构看，Hyperframes 是一个 TypeScript monorepo，核心包包括：

- hyperframes：CLI，用来创建、预览、检查和渲染 composition
- @hyperframes/core：类型、解析器、生成器、lint、runtime 和 frame adapters
- @hyperframes/engine：基于 Puppeteer 与 FFmpeg 的逐帧捕获引擎
- @hyperframes/producer：完整渲染流水线，组合捕获、编码和音频混合
- @hyperframes/studio：浏览器里的可视化 composition 编辑器
- @hyperframes/player：可嵌入的播放器 Web Component
- @hyperframes/shader-transitions：用于视频 composition 的 WebGL shader 转场

这套架构的思路很清楚：

底层用浏览器作为渲染环境，中间用 core 描述 composition 与运行时能力，上层通过 CLI、producer、studio、player 把能力开放给开发者、自动化系统和未来的可视化编辑界面。

换句话说，它不是一个单点工具，而是想成为“HTML 到视频”的基础设施。

## 五、为什么说它适合智能体？

Hyperframes 不只是宣传上说“Built for agents”，它确实在设计上踩中了智能体工作流的几个关键点。

### 1. 输入格式简单

HTML 天然可读。智能体可以直接生成、修改、插入片段，不需要理解复杂二进制工程文件。

### 2. 命令可执行

init、preview、render、lint 这些命令构成了明确的开发循环。智能体可以一步步执行，并根据结果继续修正。

### 3. 输出可验证

最终产物是 MP4 文件。是否生成成功、文件是否存在、时长是否正确、是否通过 lint，都可以被程序化检查。

### 4. 能和素材处理链路结合

官方 skills 里还提到 TTS、转写、背景移除等媒体预处理能力。也就是说，一个智能体未来可以从“主题”一路走到“脚本、配音、字幕、动画、渲染”的完整链路。

这正是 AI 视频生成真正落地时需要的能力：不是只生成一段炫酷 demo，而是能稳定进入生产流程。

## 六、适合哪些场景？

我觉得 Hyperframes 特别适合下面几类场景：

- 产品介绍视频：用页面、logo、截图和动效快速生成短片
- 数据可视化视频：把图表、榜单、趋势变化变成动画
- 社交媒体短视频：生成 9:16 竖屏标题卡、字幕卡、信息流视频
- 教程和说明视频：把文档、PPT、网页内容转成可视化讲解
- 批量内容生产：同一套模板替换文案、图片、配音后批量渲染
- AI 智能体视频工作流：让 Agent 自动写 composition、调试并导出 MP4

尤其是最后一点，可能是它最有想象力的地方。

过去智能体写一篇文章很容易，生成一张图也越来越容易，但要生成一个结构完整、可修改、可复现的视频，还缺一套工程化中间层。Hyperframes 正是在补这个空位。

## 七、现在的局限也要看清

当然，Hyperframes 目前还不是“万能视频工厂”。从官方对比说明看，它今天仍有一些边界：

- 分布式渲染能力还不如 Remotion Lambda 成熟
- 对复杂团队工作流来说，生态和最佳实践仍在早期
- 使用前需要 Node.js 22 及以上，并依赖 FFmpeg
- 如果团队已有深度 React 视频组件资产，迁移未必划算

所以它更适合愿意拥抱 HTML-first、Agent-first 工作流的开发者和内容自动化团队，而不是所有视频生产场景的唯一答案。

## 八、如何快速上手？

如果你只是想体验，可以按官方 Quick Start 走：

```bash
npx hyperframes init my-video
cd my-video
npx hyperframes preview
npx hyperframes render
```

如果你想让 AI 编程助手参与创作，可以安装它提供的 skills：

```bash
npx skills add heygen-com/hyperframes
```

官方提到这些 skills 会教会智能体如何写正确的 composition、GSAP 时间线、Tailwind v4 浏览器运行时样式，以及不同动画 runtime 的适配方式。

这其实很符合未来 AI 工具的发展方向：不是只给模型一篇长文档，而是把可复用的工程经验打包成 skill，让智能体直接按最佳实践工作。

## 九、总结：视频生成开始进入 Agent 工程化阶段

Hyperframes 的出现，说明 AI 视频创作正在从“模型生成一段视频”走向“智能体组织一条视频生产流水线”。

这两件事不一样。

前者关注模型能力，后者关注工程交付。前者问“能不能生成”，后者问“能不能稳定、可控、可修改、可批量地生成”。

Hyperframes 给出的答案是：把视频重新表达为 HTML，把渲染交给浏览器和 FFmpeg，把自动化交给 CLI，把创作入口交给智能体。

这条路线未必适合所有人，但很值得关注。因为当智能体越来越多地参与内容生产时，最有价值的工具往往不是最炫的界面，而是最容易被智能体理解和调用的工程接口。

一句话总结：

Hyperframes 不是又一个视频编辑器，而是面向 AI 智能体的视频生成基础设施。它让“写网页”这件大模型擅长的事，第一次如此自然地连接到了“生成视频”。

---

更多内容欢迎关注公众号：

![公众号关注二维码](https://zmgo.oss-cn-shenzhen.aliyuncs.com/logo/qrcode_for_gh_de689d92e7f2_258.jpg)
