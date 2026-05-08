---
title: "一句话就能操作网页？阿里开源 Page Agent，把 AI 助手装进你的产品里"
date: 2026-05-08 14:33:23
categories: [AI, 公众号]
tags: [AI, 公众号同步]
description: "阿里开源的 Page Agent 用纯前端 JavaScript 把自然语言操作网页带进产品内部：不依赖浏览器插件、无头浏览器或截图识别，更适合给 SaaS、后台系统和表单流程加一个可落地的 AI 副驾驶。"
cover: "/images/wechat-sync/page-agent/cover.jpg"
---
> 原文摘要：阿里开源的 Page Agent 用纯前端 JavaScript 把自然语言操作网页带进产品内部：不依赖浏览器插件、无头浏览器或截图识别，更适合给 SaaS、后台系统和表单流程加一个可落地的 AI 副驾驶。

![](/images/wechat-sync/page-agent/cover.jpg)

## 一、为什么 Page Agent 值得看

过去一年，GUI Agent 这个方向越来越热：让 AI 不只是回答问题，而是能点击按钮、填写表单、操作界面。常见方案往往需要浏览器扩展、远程浏览器、无头浏览器，或者通过截图交给多模态模型来判断下一步。

阿里开源的 Page Agent 选择了一个更贴近产品集成的路径：把 Agent 直接放进网页里。它的定位很清晰——The GUI Agent Living in Your Webpage，也就是“住在网页里的 GUI Agent”。用户用自然语言描述目标，Page Agent 在页面内理解 DOM、规划动作并执行界面操作。

截至 2026-04-28，Page Agent 在 GitHub 上约有 17.4k stars，npm 包 page-agent 近一个月下载量约 2.0 万次，当前仓库版本为 1.8.1，采用 MIT License。

## 二、它和常见网页自动化有什么不同

Page Agent 最重要的差异，不是“也能点网页”，而是它把自动化入口前移到了业务页面内部。

### 不需要浏览器插件或无头浏览器

官方 README 强调，Page Agent 的基础集成只需要页面内 JavaScript。不需要用户安装浏览器插件，也不要求后端启动 Playwright、Selenium 或远程浏览器实例。这对企业 SaaS、CRM、ERP、运营后台尤其重要：很多场景不是要替用户接管整个浏览器，而是要在自己的产品里补一个自然语言操作层。

### 基于文本 DOM，而不是截图

它主打 text-based DOM manipulation：通过文本化的 DOM 结构来理解页面，不依赖截图，也不强制使用多模态模型。这意味着它更容易接入常规 LLM API，也更容易做权限控制、日志审计和确定性约束。

### 自带 LLM 选择权

Page Agent 支持 Bring your own LLM。示例里可以配置兼容 OpenAI 风格接口的模型，例如通义千问相关模型。对团队来说，这降低了模型供应商绑定，也方便在成本、延迟和隐私之间做取舍。

## 三、最适合落在哪些产品里

从项目文档看，Page Agent 的核心场景不是“通用浏览器机器人”，而是“产品内 AI Copilot”。

- SaaS AI Copilot：在现有产品里快速加一个能操作界面的智能助手。
- 智能表单填写：把多步点击和录入流程，压缩成一句自然语言指令。
- 企业后台提效：适合 ERP、CRM、管理后台等规则明确但点击繁琐的系统。
- 无障碍增强：让网页可以通过自然语言、语音指令或辅助阅读方式操作。
- 跨页面 Agent：可选 Chrome 扩展支持跨标签页任务，并提供 MCP Server Beta 让外部 Agent 客户端控制浏览器。

这几个场景的共同点是：页面结构属于产品方可控，任务边界相对清晰，用户目标可以映射成一串界面动作。这比开放网页上的任意自动化更容易落地。

## 四、快速开始长什么样

官方给了两种入门方式。

一种是一行脚本体验 Demo LLM：

```html
<script src="https://cdn.jsdelivr.net/npm/page-agent@1.8.1/dist/iife/page-agent.demo.js" crossorigin="true"></script>
```

另一种是 npm 安装后自行配置模型：

```bash
npm install page-agent
```

```javascript
import { PageAgent } from 'page-agent'

const agent = new PageAgent({
  model: 'qwen3.5-plus',
  baseURL: 'https://dashscope.aliyuncs.com/compatible-mode/v1',
  apiKey: 'YOUR_API_KEY',
  language: 'zh-CN',
})

await agent.execute('点击登录按钮')
```

这个 API 设计很直观：产品方把 PageAgent 实例挂到页面里，再把用户的自然语言请求交给 execute。真正复杂的部分，是页面元素抽取、动作规划、执行反馈和失败恢复。

## 五、开发者应该关注的边界

Page Agent 的方向很实用，但上线前也要看清边界。

### 页面结构质量会影响效果

既然它依赖文本 DOM，页面的语义化、可访问性标注、按钮命名、表单标签质量都会影响 Agent 判断。对产品团队来说，这反而是一个好消息：优化页面结构不仅利于 Agent，也利于无障碍和可维护性。

### 权限和审计不能省

把 Agent 放进业务页面，意味着它可能触发真实操作。生产环境应当配合权限控制、危险动作确认、操作日志、可回滚设计，以及对高风险按钮的显式约束。

### 它不是服务端爬虫替代品

项目声明里也提到，Page Agent 面向 client-side web enhancement，而不是服务端自动化工具。换句话说，它更像产品内 Copilot，不是拿来批量爬站、绕过限制或做黑盒浏览器任务的万能机器人。

## 六、为什么这个思路有价值

很多 AI 应用卡在“最后一公里”：模型能理解用户想要什么，但还要用户自己去系统里点十几步。Page Agent 的价值在于，它把大模型能力和现有 Web UI 之间补了一层轻量执行桥。

对创业团队，它可能是最快验证 AI Copilot 的方式；对企业内部系统，它可以先从重复表单、查询、配置流程开始试点；对开发者，它提供了一个观察 GUI Agent 工程化的清晰样本：如何用 DOM 表达页面，如何让 LLM 选择动作，如何把执行限定在当前网页环境里。

## 七、值得一试的开源项目

如果你正在做 Web 产品，并且用户经常需要在页面里完成重复操作，Page Agent 值得拉下来试一下。它的最大吸引力不是概念新，而是集成路径足够轻：纯前端 JavaScript、文本 DOM、自备模型、可选扩展和 MCP。

项目地址：https://github.com/alibaba/page-agent

它提醒我们一个趋势：未来的 AI Copilot 不一定总是一个聊天窗口，也可能直接生活在每一个业务页面里，理解当前界面，并把一句话变成实际操作。

---

更多内容欢迎关注公众号：

![公众号关注二维码](https://zmgo.oss-cn-shenzhen.aliyuncs.com/logo/qrcode_for_gh_de689d92e7f2_258.jpg)
