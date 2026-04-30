---
title: "Hermes Agent 上手指南：5 分钟安装一个会长期进化的 AI Agent"
date: 2026-04-14 18:25:26
categories: [AI, 公众号]
tags: [AI, 公众号同步]
description: "一篇带你快速安装并上手 Hermes Agent 的实用教程。"
cover: "/images/wechat-sync/Hermes-Agent-上手指南5-分钟安装一个会长期进化的-AI-Agent/6ba68c125fe03a78.webp"
wechat_link: "https://mp.weixin.qq.com/s/soIh2PA6q68GUhdsvNBdnw"
wechat_aid: "2247483929_1"
---
> 原公众号链接：[Hermes Agent 上手指南：5 分钟安装一个会长期进化的 AI Agent](https://mp.weixin.qq.com/s/soIh2PA6q68GUhdsvNBdnw)


![封面](/images/wechat-sync/Hermes-Agent-上手指南5-分钟安装一个会长期进化的-AI-Agent/6ba68c125fe03a78.webp)

内容摘要

一篇带你快速安装并上手 Hermes Agent 的实用教程。

这两年，大家已经不满足于“问答型 AI”了。

真正开始进入工作流的，是另一类工具：AI Agent。

它不只是回答问题，还能真正动手：读文件、跑命令、搜资料、写代码、做自动化，甚至把重复任务定时跑起来。

如果你最近在找一款开源、可扩展、能在本地或服务器上运行的 AI Agent，那么 Hermes Agent 很值得关注。

## 一、Hermes Agent 是什么？

Hermes Agent 是 Nous Research 开源的 AI Agent 框架。它既可以跑在终端里，也可以接到 Telegram、Discord、Slack、WhatsApp、Signal 等消息平台，还能通过 ACP 接到编辑器中使用。

和普通聊天机器人相比，它更像一个“可执行的 AI 助手”。

它的几个特点很值得注意：

- 不只是对话，还能调用工具真正执行任务

- 支持多种模型和提供商，不绑定单一平台

- 有跨会话记忆，能记住你的偏好和环境信息

- 会把复杂任务沉淀成 skills，越用越像你自己的工作助手

- 可以接入消息平台，让 Agent 不只活在本机终端里

- 支持定时任务、MCP、子代理并行处理等进阶能力

简单说，如果你想要的是“一个能干活的 AI”，Hermes Agent 比“一个会聊天的 AI”更接近目标。

## 二、Hermes Agent 适合谁？

如果你属于下面几类用户，会很容易感受到它的价值：

- 开发者：让 Agent 帮你看代码、改 Bug、跑测试、整理变更

- 运维 / 技术管理：把巡检、日志分析、定时报告自动化

- 内容工作者：把研究、整理、生成、排版串成流程

- 重度终端用户：希望 AI 真正接管一部分命令行工作

- 多设备用户：希望在电脑上运行 Agent，在手机上继续对话

你可以把它理解成：一个有记忆、有工具、有执行能力、还能持续积累经验的 AI 工作台。

## 三、安装前要知道的 4 件事

正式安装前，先记住几个关键信息。

### 1. 官方支持的平台

Hermes Agent 官方快速安装路径适用于：

- Linux

- macOS

- WSL2

- Android（Termux）

如果你是 Windows 用户，官方建议先安装 WSL2，再在 WSL2 终端里完成安装。

### 2. 它不是“只能用某一家模型”

Hermes Agent 支持多种模型提供商，例如：

- OpenRouter

- Anthropic

- OpenAI

- DeepSeek

- Hugging Face

- MiniMax

- Kimi / Moonshot

- GitHub Copilot

- 自定义 OpenAI 兼容接口

也就是说，你不需要因为换模型就换整套 Agent 工具链。

### 3. 模型上下文最好不要太小

官方文档特别提到：Hermes Agent 需要至少 64K context 的模型。

原因很简单：Agent 不是单轮问答，它要维护上下文、调用工具、处理多步任务。如果上下文太小，体验会明显变差，甚至无法正常工作。

### 4. 它可以先本地跑，再迁移到服务器

Hermes Agent 不要求你一开始就折腾复杂部署。

你可以先在自己的电脑上安装体验，后面再切到 Docker、SSH 远程环境，甚至消息平台网关。这一点对想先试用、后扩展的人很友好。

## 四、5 分钟安装 Hermes Agent

最省事的方式，就是直接运行官方安装脚本。

```bash
curl -fsSL https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh | bash
```

安装完成后，重新加载 shell 配置：

```bash
source ~/.bashrc
# 或者
source ~/.zshrc
```

然后直接启动：

```bash
hermes
```

到这里，Hermes Agent 就已经装好了。

如果你是第一次运行，推荐继续执行一次设置向导。

## 五、第一次启动后，建议立刻做这 3 件事

### 1. 跑一遍 setup

```bash
hermes setup
```

这个向导会帮助你完成基础配置，包括模型提供商、工具配置等。

### 2. 选择模型

```bash
hermes model
```

这是 Hermes Agent 很重要的一步。

建议优先选择一个上下文够大、工具调用稳定的模型。对于 Agent 场景来说，“稳定执行”通常比“聊天文风”更重要。

### 3. 检查环境是否正常

```bash
hermes doctor
```

如果你刚接触 Agent 工具，这个命令非常值得跑一下。它能帮你快速排查配置或依赖问题，避免后面遇到问题不知道卡在哪。

## 六、装好之后，可以先试什么？

如果你第一次打开 Hermes，不知道要说什么，可以直接从下面几类问题开始。

### 1. 让它调用终端

比如：

“帮我看看当前磁盘占用情况，并列出最大的几个目录。”

这类问题的意义在于，你会立刻感受到它和普通聊天 AI 的区别：它会真的去执行命令，而不是只给你纸面建议。

### 2. 让它处理文件

比如：

“帮我扫描当前项目，找出最核心的入口文件，并解释一下项目结构。”

对于代码库熟悉、文档梳理、配置排查，这类能力很实用。

### 3. 试试 slash commands

Hermes 支持很多终端内命令，例如：

- /help

- /tools

- /model

- /skills

- /compress

这意味着它既是一个 AI 对话工具，也是一套可操作的终端交互界面。

### 4. 试试恢复会话

退出后，可以继续之前的上下文：

```bash
hermes --continue
# 或短写
hermes -c
```

这对长期任务特别重要。你不用每次都从头解释背景。

## 七、Hermes Agent 为什么比“普通 AI CLI”更有意思？

我觉得它最有意思的点，不只是“能调用工具”，而是下面三件事组合在一起：

第一，它有记忆。

它不只是记住聊天内容，而是会逐步形成对你的偏好、环境和工作方式的理解。

第二，它有 skills。

当 Agent 解决过复杂问题后，可以把方法沉淀成 skill，后面再遇到类似任务时直接复用。这种“越用越顺手”的感觉，是很多普通 AI 工具不具备的。

第三，它可以多入口工作。

你可以在终端里调它，也可以把它接到消息平台里，让它在服务器上跑、在手机上对话。这会让 Agent 从“单机工具”变成“随时可调用的工作助手”。

## 八、几个常用命令，先收藏

如果你准备开始用，下面这些命令最常见：

```bash
hermes # 启动交互式会话
hermes setup # 初始化配置
hermes model # 选择模型和提供商
hermes tools # 配置工具集
hermes doctor # 诊断问题
hermes update # 更新到最新版本
hermes gateway # 配置/启动消息平台网关
hermes --continue # 继续最近一次会话
```

如果你已经是 OpenClaw 用户，还可以试：

```bash
hermes claw migrate
```

官方支持从 OpenClaw 迁移部分设置、技能和数据。

## 九、进阶玩法：别只把它当成“命令行聊天工具”

很多人第一次安装 Hermes，只会把它当成一个更强的 CLI 聊天助手。

但实际上，它更值得探索的方向是：

- 接入 Telegram / Discord 等平台，随时调用

- 接入 MCP，扩展更多外部能力

- 配置 cron，让它自动跑日报、监控、研究任务

- 在远程服务器上运行，让 Agent 长时间工作

- 在编辑器中通过 ACP 使用 Hermes

也就是说，Hermes 的价值不止于“对话”，而在于“把 AI 编进工作流”。

## 十、一个更务实的建议

如果你准备第一次试 Hermes Agent，不要一上来就想把所有功能都配齐。

最合适的顺序其实是：

- 先安装并跑起来

- 先选一个稳定模型

- 先体验终端工具调用

- 再尝试恢复会话和 skills

- 最后再接消息平台、MCP、cron 这些进阶能力

这样上手成本最低，也最容易真正用起来。

结语

Hermes Agent 的价值，不在于“它是不是最会聊天的模型壳”，而在于它把记忆、技能、工具调用、跨平台入口和自动化能力组合成了一个持续进化的 Agent 系统。

如果你想找的是一个真正能进入工作流的 AI 工具，它值得你花一个晚上装起来试试。

最后附上官方入口：

- GitHub：https://github.com/NousResearch/hermes-agent

- 文档：https://hermes-agent.nousresearch.com/docs/

- 快速安装命令：

```bash
curl -fsSL https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh | bash
```

---

更多内容欢迎关注公众号：

![公众号关注二维码](https://zmgo.oss-cn-shenzhen.aliyuncs.com/logo/qrcode_for_gh_de689d92e7f2_258.jpg)
