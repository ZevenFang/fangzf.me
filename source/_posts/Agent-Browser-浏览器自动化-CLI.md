---
title: "Vercel 新项目 Agent Browser：给 AI Agent 准备的浏览器自动化 CLI"
date: 2026-05-08 14:33:19
categories: [AI, 公众号]
tags: [AI, 公众号同步]
description: "Vercel Labs 的 Agent Browser 是一个用 Rust 写的浏览器自动化命令行工具，核心思路是让 AI Agent 用稳定的命令、快照 refs、截图、网络拦截、登录状态和安全策略来操作浏览器。它不是又一个录制脚本工具，而是面向 Agent 工作流的浏览器控制层。"
cover: "/images/wechat-sync/agent-browser-cli/cover.png"
---
> 原文摘要：Vercel Labs 的 Agent Browser 是一个用 Rust 写的浏览器自动化命令行工具，核心思路是让 AI Agent 用稳定的命令、快照 refs、截图、网络拦截、登录状态和安全策略来操作浏览器。它不是又一个录制脚本工具，而是面向 Agent 工作流的浏览器控制层。

![](/images/wechat-sync/agent-browser-cli/cover.png)

Vercel Labs 最近开源了一个很值得关注的项目：Agent Browser。

项目地址是：

https://github.com/vercel-labs/agent-browser

它的官方描述很短：Browser automation CLI for AI agents。换成更直白的话说，它是一个给 AI Agent 使用的浏览器自动化命令行工具。

截至页面抓取时，仓库已有约 30.8k stars、1.9k forks，主要语言是 Rust，许可证是 Apache-2.0。这个热度说明，开发者社区对“让 Agent 稳定操作真实浏览器”这件事有非常强的需求。

## 一、为什么 AI Agent 需要新的浏览器工具？

传统浏览器自动化工具已经很多，比如 Selenium、Playwright、Puppeteer。但这些工具最初主要面向测试工程师和脚本开发者：写代码、定位元素、断言结果、集成 CI。

AI Agent 的需求不太一样。

它更像一个在终端里工作的操作者，需要不断地：

- 打开页面
- 读取当前页面结构
- 判断哪个按钮应该点
- 输入表单
- 等待页面变化
- 截图确认视觉状态
- 处理登录态和多标签页
- 把每一步结果反馈给模型继续决策

Agent Browser 把这些动作包装成稳定的 CLI 命令，并特别强调 accessibility snapshot 和 refs。AI 可以先拿到页面快照，再用 `@e1`、`@e2` 这样的 ref 精确操作元素。

这就是它和普通“浏览器脚本工具”的关键区别：它不是只服务人类写脚本，而是在为 LLM 的交互闭环做接口设计。

## 二、安装方式

README 给出了几种安装方式。最推荐的是全局安装：

```bash
npm install -g agent-browser
agent-browser install
```

这里的 `agent-browser install` 会下载 Chrome for Testing。它是 Google 官方面向自动化场景的 Chrome 渠道。

如果希望在项目里固定版本，可以作为本地依赖安装：

```bash
npm install agent-browser
agent-browser install
```

macOS 用户也可以用 Homebrew：

```bash
brew install agent-browser
agent-browser install
```

Rust 用户可以用 Cargo：

```bash
cargo install agent-browser
agent-browser install
```

如果要从源码构建：

```bash
git clone https://github.com/vercel-labs/agent-browser
cd agent-browser
pnpm install
pnpm build
pnpm build:native
pnpm link --global
agent-browser install
```

Linux 环境下，如果缺系统依赖，可以直接让它安装：

```bash
agent-browser install --with-deps
```

升级也很直接：

```bash
agent-browser upgrade
```

它会自动检测安装方式，比如 npm、Homebrew 或 Cargo，然后执行对应的升级命令。

## 三、最基本的使用流程

Agent Browser 的快速上手非常像“命令行版浏览器遥控器”。

一个最小流程是：

```bash
agent-browser open example.com
agent-browser snapshot
agent-browser click @e2
agent-browser fill @e3 "test@example.com"
agent-browser get text @e1
agent-browser screenshot page.png
agent-browser close
```

这里最重要的是 `snapshot`。

它会输出页面的 accessibility tree，并给可交互元素分配 refs。后续命令可以直接用这些 refs 操作元素，例如：

```bash
agent-browser click @e2
agent-browser fill @e3 "test@example.com"
agent-browser get text @e1
```

对 AI Agent 来说，这比猜 CSS selector 更稳定，也比只看截图更容易自动化。

当然，它也支持传统选择器：

```bash
agent-browser click "#submit"
agent-browser fill "#email" "test@example.com"
agent-browser find role button click --name "Submit"
```

## 四、核心命令可以覆盖大多数浏览器动作

Agent Browser 的命令覆盖面很广。常见动作包括：

```bash
agent-browser open <url>
agent-browser click <sel>
agent-browser dblclick <sel>
agent-browser focus <sel>
agent-browser type <sel> <text>
agent-browser fill <sel> <text>
agent-browser press <key>
agent-browser hover <sel>
agent-browser select <sel> <val>
agent-browser check <sel>
agent-browser uncheck <sel>
agent-browser scroll <dir> [px]
agent-browser upload <sel> <files>
agent-browser screenshot [path]
agent-browser pdf <path>
agent-browser snapshot
agent-browser eval <js>
agent-browser close
```

如果只是读取信息，也有一组 get 命令：

```bash
agent-browser get text <sel>
agent-browser get html <sel>
agent-browser get value <sel>
agent-browser get attr <sel> <attr>
agent-browser get title
agent-browser get url
agent-browser get count <sel>
agent-browser get box <sel>
agent-browser get styles <sel>
```

这让 Agent 可以在“观察—行动—再观察”的循环里不断获得结构化反馈。

## 五、语义定位：更适合 Agent 的元素查找方式

除了 CSS selector，Agent Browser 支持更接近人类理解方式的 semantic locators。

例如：

```bash
agent-browser find role button click --name "Submit"
agent-browser find text "Sign In" click
agent-browser find label "Email" fill "test@test.com"
agent-browser find first ".item" click
agent-browser find nth 2 "a" text
```

这类命令非常适合模型生成，因为模型往往知道“我要点击名为 Submit 的按钮”，但不一定知道页面里实际 CSS 结构是什么。

## 六、等待、批处理和一次性工作流

浏览器自动化最容易出问题的地方，是页面还没加载完就开始操作。

Agent Browser 提供了 wait 命令：

```bash
agent-browser wait <selector>
agent-browser wait 1000
agent-browser wait --text "Welcome"
agent-browser wait --url "**/dash"
agent-browser wait --load networkidle
agent-browser wait --fn "window.ready === true"
```

如果要等待元素消失：

```bash
agent-browser wait --fn "!document.body.innerText.includes('Loading...')"
agent-browser wait "#spinner" --state hidden
```

更适合 Agent 的是 batch。它可以把多步浏览器操作放进一次 CLI 调用，减少每次启动进程的开销。

```bash
agent-browser batch "open https://example.com" "snapshot -i" "screenshot"
```

遇到错误就停止：

```bash
agent-browser batch --bail "open https://example.com" "click @e1" "screenshot"
```

也可以通过 JSON 从 stdin 输入：

```bash
echo '[
  ["open", "https://example.com"],
  ["snapshot", "-i"],
  ["click", "@e1"],
  ["screenshot", "result.png"]
]' | agent-browser batch --json
```

这对 AI Agent 很有价值：模型可以规划一串动作，工具层一次执行，再把结果统一返回。

## 七、登录态和会话管理

真实网页任务绕不开登录。

Agent Browser 提供了多种方式复用登录状态：Chrome profile、persistent profile、session-name、state file、auth vault 等。

最简单的是复用已有 Chrome profile：

```bash
agent-browser profiles
agent-browser --profile Default open https://gmail.com
agent-browser --profile "Work" open https://app.example.com
```

也可以用一个独立 profile 目录长期保存状态：

```bash
agent-browser --profile ~/.myapp-profile open myapp.com
agent-browser --profile ~/.myapp-profile open myapp.com/dashboard
```

如果更喜欢自动保存 cookies 和 localStorage，可以用 session-name：

```bash
agent-browser --session-name twitter open twitter.com
export AGENT_BROWSER_SESSION_NAME=twitter
agent-browser open twitter.com
```

项目还支持从已经登录的 Chrome 中导出状态：

```bash
"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" --remote-debugging-port=9222
agent-browser --auto-connect state save ./my-auth.json
agent-browser --state ./my-auth.json open https://app.example.com/dashboard
```

但这里一定要注意安全：state 文件里可能包含明文 session token，应该加入 `.gitignore`，不要提交到仓库。

## 八、截图、标注和视觉反馈

Agent Browser 支持普通截图，也支持 annotated screenshot。

```bash
agent-browser screenshot page.png
agent-browser screenshot --annotate ./page.png
```

标注截图会给可交互元素叠加编号，例如 `[1]`、`[2]`，并把它们映射到 `@e1`、`@e2`。

这对多模态模型很有用：模型可以先看图理解页面布局，再用 ref 执行动作。

## 九、调试、网络和前端专项能力

Agent Browser 不只是点击按钮。它还提供了不少面向前端开发和测试的能力。

例如网络拦截：

```bash
agent-browser network route <url>
agent-browser network route <url> --abort
agent-browser network route <url> --body <json>
agent-browser network requests --filter api
agent-browser network har start
agent-browser network har stop output.har
```

调试页面错误和控制台：

```bash
agent-browser console
agent-browser console --json
agent-browser errors
agent-browser errors --clear
agent-browser inspect
```

对 React 应用，它还支持 React tree、组件 inspect、render recording 和 Web Vitals：

```bash
agent-browser open --enable react-devtools <url>
agent-browser react tree
agent-browser react inspect <fiberId>
agent-browser react renders start
agent-browser react renders stop --json
agent-browser vitals <url> --json
```

这对 Next.js、Remix、Vite React、TanStack Start 等应用都很有吸引力。

## 十、安全能力：Agent 操作浏览器必须有边界

让 AI 操作浏览器，安全边界非常重要。

Agent Browser 提供了一些 opt-in 的安全功能：

```bash
agent-browser --content-boundaries open https://example.com
agent-browser --allowed-domains "example.com,*.example.com" open https://example.com
agent-browser --action-policy ./policy.json open https://example.com
agent-browser --confirm-actions eval,download open https://example.com
agent-browser --max-output 50000 snapshot
```

这些能力对应几个核心问题：

- content boundaries：帮助模型区分页面内容和工具输出，降低 prompt injection 风险；
- allowed domains：限制浏览器只能访问可信域名；
- action policy：用静态策略限制危险动作；
- confirm actions：对 eval、download 等敏感操作要求确认；
- max output：防止页面输出撑爆上下文。

如果把 Agent Browser 放进长期运行的自动化系统，这些配置不应该被当成可选项，而应该是默认防线。

## 十一、AI Chat 和 Dashboard

Agent Browser 还有更高层的交互方式：chat 命令。

它可以把自然语言翻译成 agent-browser 命令，然后执行：

```bash
agent-browser chat "open google.com and search for cats"
agent-browser chat
agent-browser -q chat "summarize this page"
agent-browser -v chat "fill in the login form"
agent-browser --model openai/gpt-4o chat "take a screenshot"
```

要启用 AI Chat，需要配置 Vercel AI Gateway：

```bash
export AI_GATEWAY_API_KEY=***
export AI_GATEWAY_MODEL=anthropic/claude-sonnet-4.6
export AI_GATEWAY_URL=https://ai-gateway.vercel.sh
```

它还提供本地 dashboard：

```bash
agent-browser dashboard start
agent-browser dashboard start --port 8080
agent-browser open example.com
agent-browser dashboard stop
```

Dashboard 可以显示 live viewport、命令活动流、console 输出，也能创建新 session。对调试 Agent 浏览器行为来说，这比纯日志友好很多。

## 十二、一个实用场景：自动登录后的表单提交

假设你要让 Agent 在一个已经登录的网站里填写表单，可以这样组织流程：

```bash
agent-browser --profile ~/.work-profile open https://app.example.com/form
agent-browser snapshot -i
agent-browser find label "Email" fill "test@example.com"
agent-browser find label "Message" fill "Hello from Agent Browser"
agent-browser find role button click --name "Submit"
agent-browser wait --text "Success"
agent-browser screenshot success.png
```

如果希望一次执行：

```bash
agent-browser batch --bail \
  "open https://app.example.com/form" \
  "snapshot -i" \
  "find label Email fill test@example.com" \
  "find label Message fill 'Hello from Agent Browser'" \
  "find role button click --name Submit" \
  "wait --text Success" \
  "screenshot success.png"
```

真实项目里，我会更建议把登录态放到独立 profile 或 state 文件里，同时加上 allowed-domains 和 action policy，避免 Agent 跑出预期边界。

## 十三、它适合谁？

Agent Browser 适合几类人：

- 正在做 AI Agent，需要让模型可靠操作网页的人；
- 做前端 E2E、视觉检查、网页抓取、表单自动化的开发者；
- 想把浏览器工具暴露给命令行 Agent，而不是把 Playwright SDK 直接塞进模型上下文的人；
- 需要登录态复用、多 session、网络拦截、截图标注和安全策略的自动化团队。

它不一定适合只想写少量固定测试脚本的人。那种场景下，Playwright 代码可能更直观。

但如果你的核心问题是“让 AI 一步一步操作真实网页，并把观察结果喂回模型”，Agent Browser 的设计明显更贴近这个需求。

结语

Agent Browser 的价值，不在于它又发明了一套浏览器 API，而在于它把浏览器自动化重新包装成适合 AI Agent 使用的命令协议。

它把页面观察变成 snapshot，把元素操作变成 refs，把登录态、截图、网络、调试和安全策略都放进统一 CLI。这样一来，Agent 不需要理解所有浏览器 SDK 细节，也能在可控边界里执行复杂网页任务。

未来的 AI Agent 很可能不只是调用搜索 API，而是会越来越多地操作真实网页应用。Agent Browser 这类工具，就是这个方向上的基础设施。

---

更多内容欢迎关注公众号：

![公众号关注二维码](https://zmgo.oss-cn-shenzhen.aliyuncs.com/logo/qrcode_for_gh_de689d92e7f2_258.jpg)
