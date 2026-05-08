---
title: Anthropic 把金融 AI 拆成了 10 个“专业同事”
date: 2026-05-08 14:46:22
description: "Anthropic 开源 financial-services 参考项目：不是一个聊天机器人，而是一套面向投行、研报、私募、财富管理与基金运营的 Claude 插件、技能和托管 Agent 模板。它真正值得看的，是“同一份源文件，两种交付形态”、MCP 数据连接器，以及对金融场景里权限隔离和人工签核的克制设计。"
categories:
- AI
tags:
- Anthropic
- Claude
- AI Agent
- 金融科技
- MCP
---

![文章封面](/images/wechat-sync/anthropic-financial-services/cover.png)

> Anthropic 开源 financial-services 参考项目：不是一个聊天机器人，而是一套面向投行、研报、私募、财富管理与基金运营的 Claude 插件、技能和托管 Agent 模板。它真正值得看的，是“同一份源文件，两种交付形态”、MCP 数据连接器，以及对金融场景里权限隔离和人工签核的克制设计。

Anthropic 最近放出了一个很有意思的参考项目：financial-services。

项目地址：https://github.com/anthropics/financial-services

它不是一个“让 AI 帮你炒股”的工具，也不是一个单体金融助手。更准确地说，这是 Anthropic 为金融服务行业准备的一套 Claude 工作流样板：把投行、股票研究、私募、财富管理、基金行政、KYC 等高频场景，拆成可安装的 Cowork 插件和可通过 Managed Agents API 部署的托管 Agent 模板。

如果你正在思考企业 AI Agent 怎么落地，尤其是高合规、高专业度、强数据依赖的金融场景，这个仓库比普通 Demo 更值得研究。

## 一、它到底是什么

从 README 看，这个项目的定位很清楚：Reference agents, skills, and data connectors for financial-services workflows。

翻译成人话就是：

- 它提供一批金融行业常见工作的“参考 Agent”；
- 每个 Agent 都有自己的系统提示词、技能包和工具权限；
- 同一套源文件既可以作为 Claude Cowork 插件安装，也可以作为 Claude Managed Agent 模板部署到你自己的流程引擎后面；
- 数据层通过 MCP 连接 Morningstar、FactSet、S&P Global、LSEG、PitchBook、Daloopa 等金融数据提供商，实际使用通常还需要对应订阅或 API 权限。

仓库当前包含 363 个文件，核心结构大致是四块：

| 目录 | 作用 |
|---|---|
| plugins/agent-plugins | 10 个端到端工作流 Agent |
| plugins/vertical-plugins | 按金融垂直领域组织的技能、命令和 MCP 配置 |
| plugins/partner-built | LSEG、S&P Global 等伙伴插件 |
| managed-agent-cookbooks | 10 个可部署的 Managed Agent cookbook |

这里最重要的一句话是：Everything here is available two ways from one source。

也就是说，它不是“插件一份、API 部署一份”的重复工程，而是用同一套 prompt 和 skill 作为源头，再分别包装成 Cowork 插件和 Managed Agent 模板。

## 二、10 个金融 Agent：不是泛泛而谈，而是按岗位切开

这个项目里有 10 个命名 Agent：

| Agent | 主要工作 |
|---|---|
| Pitch Agent | 可比公司、先例交易、LBO 到品牌化 pitch deck |
| Meeting Prep Agent | 客户会议前的 briefing pack |
| Market Researcher | 行业概览、竞争格局、同业估值和想法清单 |
| Earnings Reviewer | 财报电话会和 filings 到模型更新与研报草稿 |
| Model Builder | DCF、LBO、三表模型、comps，在 Excel 里工作 |
| Valuation Reviewer | 读取 GP package，运行估值模板，准备 LP reporting |
| GL Reconciler | 找总账和明细账 break，追根因，生成签核报告 |
| Month-End Closer | 应计、roll-forward、variance commentary |
| Statement Auditor | LP statement 分发前审计 |
| KYC Screener | 解析开户材料，跑规则引擎，标记缺口 |

这比“金融 AI 助手”四个字具体得多。

它没有试图让一个超级 Agent 同时做所有事情，而是按金融机构内部真实流程来切：前台覆盖与投行、中台研究建模、后台基金行政与财务运营、运营与合规 onboarding。

这种拆法有两个好处：

1. prompt 更容易写清楚，因为每个 Agent 的职责边界明确；
2. 工具权限更容易收敛，因为不同岗位本来就不应该拥有同样的读写和外部系统权限。

## 三、真正有价值的是 Skills，而不是“会聊天”

仓库里的 vertical-plugins 才是底层能力库。

例如 financial-analysis 这个核心插件包含 comps、DCF、LBO、三表模型、Excel audit、deck QC、PPT 和 XLSX 生成等技能；equity-research 里有 earnings analysis、initiating coverage、thesis tracker；investment-banking 里有 CIM、teaser、buyer list、merger model、deal tracker；private-equity 里有 deal screening、IC memo、portfolio monitoring、value creation plan。

这说明 Anthropic 对企业 Agent 的理解不是“模型更聪明就够了”，而是把专业知识写成可复用的 Skill：

- 工作流应该怎么拆；
- 输出应该长什么样；
- 哪些数字要交叉检查；
- 哪些模板和术语要遵守；
- 哪些环节必须留给人工签核。

对企业来说，这一点很关键。真正能落地的 Agent，往往不是拥有更多魔法，而是把组织里的 SOP、模板、检查清单和例外处理方式沉淀进技能系统。

## 四、MCP 是数据入口，但项目没有假装“接上就能用”

金融 Agent 的核心瓶颈之一是数据。

这个项目把 MCP connector 集中在 financial-analysis 插件里，列出了 Daloopa、Morningstar、S&P Global、FactSet、Moody's、MT Newswires、Aiera、LSEG、PitchBook、Chronograph、Egnyte 等服务。

这是一种很现实的设计：

- Agent 不应该凭空编财务数据；
- 估值、comps、研报、交易数据必须来自受控数据源；
- 企业可以替换 connector，接入自己的数据提供商和内部系统；
- README 也明确提醒：MCP access may require a subscription or API key。

所以这个仓库不是一个开箱即用的免费金融数据平台。它更像是一套架构蓝图：告诉你 Agent 应该如何连接外部金融数据、如何把数据能力挂到具体工作流里。

## 五、Managed Agent cookbook 展示了“生产化”的样子

如果只看插件，它像是 Claude 内部的工作流扩展；但 managed-agent-cookbooks 让它更接近企业生产部署。

每个 cookbook 都有 agent.yaml、subagents、steering-examples 和 README。比如 Pitch Agent 的部署配置里，orchestrator 引用同一份系统提示词，同时配置 CapIQ、Daloopa 这样的 MCP server，再挂上 researcher、modeler、deck-writer 三个子 Agent。

GL Reconciler 则配置 internal-gl 和 subledger 两个只读 MCP server，并把工作拆成 reader、critic、resolver。

这些模板体现了几个生产化思想：

1. Orchestrator 负责调度，不直接拿所有危险权限；
2. 子 Agent 按任务切分，有的只读，有的只写，有的只验证；
3. 产物统一落在 ./out/，而不是假设用户正在打开一个 Office 文档；
4. handoff_request 用来把一个 Agent 的结果交给另一个 Agent，例如 GL Reconciler 的 verified breaks 可以交给 Month-End Closer。

这已经不是“写一个漂亮 prompt”的阶段，而是在描述 Agent 与企业流程引擎、权限系统、数据系统之间该怎么协作。

## 六、最值得学习的是安全分层

金融场景里，一个 Agent 读到外部 PDF、邮件、报表、客户材料后，如果还能直接写文件、执行脚本、调用内部系统，就会有典型的 prompt injection 风险。

这个项目在多个 README 里反复使用三层隔离设计：

| 层级 | 是否接触不可信文档 | 权限 |
|---|---|---|
| Reader | 是 | 通常只有 Read、Grep，没有外部 connector，没有 Write |
| Orchestrator / Verifier | 否 | 调度、读取受信数据源、复核结果 |
| Writer | 否 | 负责生成最终文档，但不直接打开外部不可信文件 |

例如 GL Reconciler 里，reader 会读取 counterparty/custodian statements，但它没有 shell、write 或 firm system 权限；critic 会独立复核 break；resolver 才写 exception report，而且不直接打开外部文件。

KYC Screener、Market Researcher、Valuation Reviewer、Statement Auditor 也采用类似模式：接触不可信输入的 Agent 被限制为只读；持有 Write 的 Agent 不直接接触外部材料。

这点非常重要。它说明企业 Agent 的安全设计不能只靠“提示词里说不要被诱导”。更稳妥的方式是：让攻击内容无法同时接触到高危工具和敏感系统。

## 七、它也很克制：不做投资建议，不自动交易，不自动审批

README 顶部有一段重要免责声明：这些 Agent 只起草分析师工作产物，例如模型、memo、research note、reconciliation；它们不提供投资、法律、税务或会计建议，不执行交易，不绑定风险，不记账，不批准 onboarding。每个输出都要交给合格专业人士 review。

这不是普通的法律套话，而是产品边界。

金融 AI 很容易被包装成“自动投研”“自动投顾”“自动合规”。但在真实机构里，真正能先落地的往往是：

- 生成草稿；
- 补全模型；
- 汇总材料；
- 找异常；
- 生成待签核报告；
- 把结果送到人类专业人士手里。

这个仓库把 Agent 放在“辅助专业人士产出工作底稿”的位置，而不是“替代专业人士作决策”的位置。这个边界反而让它更可信。

## 八、对企业 Agent 落地的启发

我觉得这个项目有 5 个值得借鉴的设计原则：

### 1. 以岗位和流程定义 Agent，而不是以模型能力定义 Agent

Pitch、KYC、GL recon、month-end close 都是组织里的真实工作流。Agent 的边界最好跟业务责任边界一致。

### 2. 把知识沉淀成 Skill，而不是散落在一次性 prompt 里

Skill 文件能复用、能审查、能版本化，也更接近企业 SOP。

### 3. 数据连接器要显式、受控、可替换

MCP server 的存在让数据来源可见，也让权限配置有地方落地。

### 4. 写权限和不可信输入要隔离

Reader / Orchestrator / Writer 的分层，比单纯靠模型自觉更可靠。

### 5. 人工签核是系统的一部分，不是失败补丁

项目反复强调 staged for human sign-off。对于金融这种行业，这不是保守，而是现实。

## 九、我的判断

financial-services 不是一个普通开源项目。它更像 Anthropic 在展示：面向高价值行业的 Agent，不应该只是“聊天框 + 工具调用”，而应该是：

- 有清晰职责边界的专业 Agent；
- 有可审查、可复用的 Skill；
- 有受控数据入口；
- 有权限隔离；
- 有人类签核；
- 有插件形态，也有 API 托管形态。

如果你只想找一个能直接跑的金融工具，它可能没那么“开箱即用”。因为很多 MCP 数据源需要订阅，企业内部流程也要自己接。

但如果你想研究金融行业的企业级 AI Agent 应该怎么设计，这个仓库很值得拆开看。它给出的不是一个万能助手，而是一组更接近真实组织结构的“AI 专业同事”。

项目地址：
https://github.com/anthropics/financial-services

---

更多内容欢迎关注公众号：

![公众号关注二维码](https://zmgo.oss-cn-shenzhen.aliyuncs.com/logo/qrcode_for_gh_de689d92e7f2_258.jpg)
