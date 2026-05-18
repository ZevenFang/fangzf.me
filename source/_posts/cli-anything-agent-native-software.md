---
title: Agent 终于能用真软件了：CLI-Anything 想把所有软件变成命令行工具
date: 2026-05-18 10:22:07
description: "CLI-Anything 不是再造“AI 版软件”，而是把真实软件包装成 Agent 可稳定调用的 CLI，让 Blender、FreeCAD、LibreOffice 等复杂工具变成 Agent 原生能力。"
categories:
- AI
tags:
- Agent
- CLI
- 开源项目
- AI工具
---

> CLI-Anything 不是再造“AI 版软件”，而是把真实软件包装成 Agent 可稳定调用的 CLI，让 Blender、FreeCAD、LibreOffice 等复杂工具变成 Agent 原生能力。

![文章封面](/images/wechat-sync/cli-anything-agent-native-software/cover.jpg)

## 一、Agent 卡住的地方，不是“不会想”，而是“不会用软件”

过去一年，AI Agent 的推理、写代码、查资料能力进步很快，但一到真实软件就容易露怯：它可以告诉你 Blender 里应该怎么建模，却很难像熟练用户一样稳定地打开界面、点击菜单、调整参数、导出结果。

问题不在于 Agent 不够聪明，而在于今天的软件大多是为人类手眼协同设计的。GUI 对人友好，对 Agent 却很脆弱：按钮位置会变、窗口状态会变、截图 OCR 会误判，RPA 式点击一旦偏一点，整个任务就可能崩掉。

HKUDS 的 CLI-Anything 切中的正是这个缝隙。项目主页把它概括为一句话：Today's Software Serves Humans. Tomorrow's Users will be Agents. 它想做的是把世界上已有的软件，变成 Agent 可以直接调用、可以测试、可以组合的命令行工具。

项目地址：https://github.com/HKUDS/CLI-Anything

## 二、它的核心判断：CLI 是人类和 Agent 的共同接口

CLI-Anything 没有选择“让 Agent 学会点 GUI”，而是反过来问：能不能把 GUI 软件包装成结构化 CLI？

这个方向很务实。命令行天然适合 Agent：输入是文本，输出也可以是文本或 JSON；命令可以被脚本串联；`--help` 本身就是可发现的文档；执行结果可复现，也更容易写测试。

CLI-Anything 的目标不是替代原软件，而是在软件外面加一层 Agent-native 的操作面。比如：

- 让 Blender 通过 `blender --background --python` 执行真实渲染能力；
- 让 LibreOffice 通过 headless 模式完成真实文档转换；
- 让 Shotcut / Kdenlive 通过 MLT XML 与渲染后端产出视频；
- 让 QGIS、FreeCAD、OBS Studio、Audacity 等复杂工具也能被 Agent 以命令行方式编排。

关键在于：Agent 不再需要猜一个按钮在哪里，而是调用一个有参数、有返回值、有测试覆盖的命令。

## 三、七阶段流水线：把“做一个 CLI”变成工程方法

CLI-Anything 最有价值的地方，不只是仓库里已经有很多 CLI，而是它沉淀了一套可复制的方法论。官方 HARNESS.md 把生成一个 Agent 可用 CLI 的过程拆成七个阶段：

### 1. 分析代码库：找到后端引擎、数据模型、已有 CLI、GUI 动作和 API 的对应关系。
### 2. 设计 CLI 架构：规划命令分组、状态模型、JSON 输出、人类可读输出和 REPL 模式。
### 3. 实现 CLI：从数据层、探测命令、修改命令、真实软件后端调用、导出流程到 undo/redo。
### 4. 先写测试计划：在 TEST.md 里规划单元测试、端到端测试和真实工作流。
### 5. 实现测试：不仅测中间文件，还要调用真实软件后端验证最终产物。
### 6. 写入测试结果：把 pytest 输出、通过率、覆盖缺口记录到 TEST.md。
### 7. 发布与安装：生成 setup.py，把 CLI 安装到 PATH，并提供 Agent 可读的 SKILL.md。

这套流程背后的思想是“不要做玩具封装”。项目文档里反复强调：CLI 必须调用真实软件完成渲染和导出，而不是用一段 Python 重新实现一个缩水版软件。

这点很重要。因为 Agent 真正需要的不是“看起来像 Blender 的玩具库”，而是能访问 Blender、FreeCAD、LibreOffice 这些成熟工具的完整能力。

## 四、SKILL.md：让工具不只是能安装，还能被 Agent 理解

CLI-Anything 另一个关键设计是 SKILL.md。

对人类来说，一个 CLI 有 README 就够了；对 Agent 来说，它还需要知道：什么时候该用这个工具、有哪些命令组、怎样请求 JSON 输出、常见错误怎么处理、有哪些真实工作流可以复用。

因此 CLI-Anything 把每个生成的工具都配成可发现的 skill。仓库中已经把 SKILL.md 统一到顶层 `skills/` 目录下，并支持用类似下面的方式安装：

```bash
npx skills add HKUDS/CLI-Anything --skill cli-anything-blender -g -y
```

这意味着工具生态不只是“人来浏览”，也可以变成 Agent 自己的工具库。Agent 遇到任务时，可以先读 skill，再决定装哪个 CLI、调用哪些命令、如何解析输出。

## 五、CLI-Hub：从单个工具走向工具市场

如果说 CLI-Anything 是生产工具的方法论，那么 CLI-Hub 就是工具分发与发现层。

项目里提供了 `cli-anything-hub` 包，当前 setup.py 里版本为 0.3.0。README 给出的典型用法是：

```bash
pip install cli-anything-hub
cli-hub install <name>
```

仓库的 `registry.json` 目前记录了 60 个 CLI 条目，覆盖 AI、视频、DevOps、Web、图形、Office、网络、3D、图表、调试、通信、科学计算等方向。除此之外，`public_registry.json` 还维护了公开 CLI 的安装来源。

这让 CLI-Anything 不再只是“给某个软件写一个 wrapper”，而是在尝试建立 Agent 的软件包生态：Agent 知道自己缺什么工具，就去 Hub 里找、安装、读取 skill，然后执行任务。

## 六、预览、Live Preview 和 trajectory：让 Agent 能看见自己做了什么

复杂创作任务还有一个难点：只给命令行返回值不够。比如让 Agent 做一辆 FreeCAD 火星车、一个 Blender 无人机模型、一张 Draw.io 架构图，最终成果必须能被视觉检查。

CLI-Anything 在 demo 里强调 preview、live preview 和 trajectory：

- preview 负责产出可查看的中间结果；
- live preview 让 Agent 在迭代过程中持续刷新当前状态；
- trajectory 把每一步命令和对应预览结果记录下来，方便回放与审计。

这相当于给 Agent 加了一条“看见结果再继续”的闭环。它不是盲目连续执行命令，而是每做一步就能检查产物，再决定下一步怎么改。

## 七、从仓库结构看项目成熟度

我本地拉取仓库后看到几个信号：

- 最近一次提交是 2026-05-17，项目仍在高频更新；
- 仓库中存在 53 个带 `agent-harness/setup.py` 的工具目录；
- `registry.json` 收录 60 个 CLI 条目；
- `skills/` 下已有 56 个 skill 目录；
- 仓库中有 127 个测试文件，简单统计到 4574 个 `test_` 测试定义；
- README 徽章显示 18 个 demos、2269 passing tests；正文中也出现了 2280 passing tests 的描述，说明项目文档仍在快速迭代，数字可能随版本更新略有出入。

这些数字不一定代表所有 CLI 都已经达到生产级，但至少说明它不是一个只有概念图的 repo。它在持续把方法论落到具体软件上：Blender、FreeCAD、QGIS、OBS、Audacity、LibreOffice、Kdenlive、Shotcut、Zotero、n8n、ComfyUI、WireMock、AdGuardHome 等都能在目录中看到对应 harness。

## 八、我认为它最值得关注的三点

### 1. 它绕开了脆弱 GUI 自动化

很多 Agent demo 看起来炫酷，本质是截图、点击、等待、再截图。只要分辨率、语言、弹窗、主题变一点，就可能失效。CLI-Anything 的路线是把软件能力暴露成命令，把“看界面猜状态”变成“读 JSON 和文件状态”。

### 2. 它坚持调用真实软件

这比“重新实现一个简化版”难，但也更有长期价值。因为真实用户需要的往往是完整的专业能力，而不是 demo 级模拟。

### 3. 它把工具使用写成可测试工程

先写 TEST.md，再实现单元测试和 E2E，最后把结果记录下来。这种流程看似笨重，但对于 Agent 工具链很必要。未来 Agent 生态里，工具不是能跑一次就行，而是要长期可复现、可升级、可审计。

## 九、可能的挑战

当然，CLI-Anything 也有明显挑战。

首先，不同软件的后端能力差异很大。有些软件天然有脚本接口，有些软件几乎只有 GUI；有些文件格式稳定，有些导出流程依赖复杂运行环境。统一方法论不等于每个软件都能低成本接入。

其次，真实软件依赖会带来安装和 CI 成本。比如 Blender、LibreOffice、QGIS、OBS 这类工具体积大、版本差异多，端到端测试会比普通 Python 包更重。

再次，Agent 能调用 CLI 只是第一步。要让它真正完成复杂任务，还需要更好的任务规划、结果评估、错误恢复和多轮预览反馈。

但这些挑战恰恰说明这个方向值得做：如果未来 Agent 真要进入专业软件工作流，它迟早要面对这些工程问题。

## 十、结语：Agent 原生软件生态的一个早期雏形

CLI-Anything 给我的感觉，不像一个单点工具，而像一个早期生态原型：

- CLI-Anything 负责把软件转成 Agent 可操作接口；
- SKILL.md 负责让 Agent 理解工具；
- CLI-Hub 负责发现和安装；
- preview / live preview / trajectory 负责把执行结果反馈给 Agent；
- 测试体系负责保证工具不是一次性 demo。

如果说 MCP 解决的是“Agent 如何连接服务和工具”，那么 CLI-Anything 关注的是另一个更接地气的问题：大量已经存在、为人类设计的桌面软件和专业软件，怎样变成 Agent 可以稳定使用的能力。

这可能是 Agent 走向真实生产力场景的一条重要路径。不是让 AI 再造一套软件，而是让 AI 学会可靠地使用我们已经拥有的那些软件。

---

更多内容欢迎关注公众号：

![公众号关注二维码](https://zmgo.oss-cn-shenzhen.aliyuncs.com/logo/qrcode_for_gh_de689d92e7f2_258.jpg)
