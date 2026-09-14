---
title: SmartTube：给 Android TV 换一个更清爽的 YouTube 客户端
date: 2026-09-14 17:01:11
description: "SmartTube 是一款专为 Android TV 和安卓电视盒子设计的开源 YouTube 客户端。本文介绍它的主要功能、兼容设备、安装更新方式和使用注意事项。"
categories:
- 开源项目
tags:
- SmartTube
- Android TV
- YouTube
- 电视盒子
- 开源
cover: "/images/wechat-sync/smarttube/cover.png"
---

> SmartTube 是一款专为 Android TV 和电视盒子设计的开源 YouTube 客户端。它针对电视大屏和遥控器优化了浏览、播放和设置体验。

![SmartTube](/images/wechat-sync/smarttube/cover.png)

家里的电视明明有一块大屏，但打开 YouTube 后，广告、赞助口播和不够顺手的遥控器操作，常常让观看体验打折。SmartTube 想解决的就是这件事：它是一款专为 Android TV 和安卓电视盒子设计的免费开源客户端，用更适合客厅大屏的方式浏览和播放 YouTube 内容。

它不是 Google 官方产品，也不是手机端 YouTube 的通用替代品。不过，如果你使用的是 Android TV、Google TV、NVIDIA Shield、小米盒子或部分旧款 Fire TV，它值得了解。

## 一、SmartTube 到底是什么？

SmartTube 是一个个人维护的开源项目，代码采用 MIT 许可证发布。它针对电视屏幕和遥控器重新设计了交互，主要功能围绕 YouTube 内容浏览与播放展开。

截至 2026 年 9 月 14 日，项目在 GitHub 上约有 3.35 万颗 Star、2039 个 Fork，最新稳定版为 `32.47 Stable`。

和在手机上安装第三方播放器不同，SmartTube 的重点不是触屏，而是十英尺之外的电视体验：文字更适合大屏浏览，焦点移动遵循遥控器逻辑，播放设置也围绕电视硬件展开。

![SmartTube 项目主界面](/images/wechat-sync/smarttube/home.png "项目主界面")

## 二、它有哪些实用功能？

### 1. 更干净的观看界面

项目说明称，应用本身没有展示广告的代码。它还可以启用 SponsorBlock，根据社区提交的时间段跳过赞助口播、片头、片尾和订阅提醒等内容。

SponsorBlock 依赖社区标注，并不是每一段都能识别；SmartTube 里也不能直接提交新的跳过片段。它更像一项可选辅助能力，而不是“所有视频百分之百无干扰”的保证。

### 2. 针对大屏和遥控器优化

SmartTube 支持遥控器按键定制、画中画、播放速度调整、画质与编码预设、直播聊天等功能。播放器中的循环播放等操作，也可以直接通过电视端界面完成。

![SmartTube 播放器界面](/images/wechat-sync/smarttube/player.jpg "播放器循环功能")

### 3. 最高支持 8K、60fps 和 HDR

项目列出了最高 8K、60fps、HDR 以及 AV1 等能力。但“支持”不等于每台电视都能流畅播放，实际效果仍取决于视频源、电视或盒子的硬件解码能力、系统版本和 HDMI 输出链路。

如果设备性能一般，合理选择分辨率和编码，比盲目追求最高规格更重要。项目目前也没有按实时带宽自动调节画质的完整能力。

### 4. 不依赖 Google Services

SmartTube 可以在不安装 Google Services 的设备上工作。需要账户功能时，可使用电视连接码进行配对。手机端不会仅凭同一 Wi-Fi 自动发现 SmartTube，必须先在电视端打开应用并显示连接码，而且无法借此自动唤醒电视。

## 三、哪些设备能用？

SmartTube 主要支持以下设备：

- Android TV 和 Google TV 电视。
- 运行 Android 的电视盒子与电视棒。
- NVIDIA Shield、Chromecast with Google TV、小米盒子。
- 运行 Android 的部分旧款 Fire TV。

它不支持 Samsung Tizen、LG webOS、Apple TV、Roku 和 iOS。手机和平板也没有官方支持，触摸操作以及鼠标、触控板滚动并不是它的设计目标。

此外，项目当前特别提示：Fire Stick 4K Select 以及使用 VegaOS 的新款 Fire TV 不兼容。购买设备前，最好先确认操作系统，而不是只看“Fire TV”这个名称。

![SmartTube 兼容设备](/images/wechat-sync/smarttube/compatibility.png "兼容设备示意")

## 四、如何安装和更新？

SmartTube 主要通过 APK 侧载安装。最稳妥的原则是只从项目官网、GitHub Releases 或项目明确给出的 F-Droid 页面获取安装包，不要使用来源不明的“修改版”。

常见安装方式包括：

- 在电视上使用 Downloader 下载，稳定版代码为 `28544`，测试版代码为 `79015`。
- 在电脑或手机上下载 APK，再通过 U 盘或文件传输工具发送到电视。
- 熟悉开发工具的用户可以通过 ADB 安装。

安装时只为实际使用的安装工具开启“允许安装未知应用”，完成后可以关闭该权限。普通 Stable 和 Beta 版本带有更新检查，但更新仍需要用户确认，并不是后台静默安装；F-Droid 版本则由 F-Droid 客户端负责更新。

对大多数人来说，优先选择 Stable。Beta 更适合愿意测试新功能并接受偶发问题的用户。

## 五、登录、隐私和安全要看清

SmartTube 的 F-Droid 版本隐私说明称，它没有开发者自建后端，也不包含遥测或分析，OAuth 登录令牌保存在设备本地。但这份说明只适用于包名为 `app.smarttube.fdroid` 的 F-Droid 版本，不能直接套用到 Stable 和 Beta。

应用仍然需要访问 Google/YouTube；启用 SponsorBlock、DeArrow 或 Return YouTube Dislike 等服务时，相关第三方会收到视频 ID。因此，它并不是离线播放器，也不能简单概括成“不会向任何第三方发送数据”。

还有一条不能忽略的安全公告：开发者在项目 README 和官网表示，其开发环境此前曾受到未知恶意软件影响，少数构建可能受影响，签名公钥也可能泄露。开发者随后重建了开发环境，并为新构建提供 VirusTotal 扫描链接。

更稳妥的做法是：只下载最新正式版本，核对 Release 页面和扫描报告；不用时可在 Google 账户安全设置中撤销 YouTube TV 等连接；对高敏感账户或无法承担风险的设备，先观望或在隔离环境中评估。

## 六、使用前还应知道这些限制

- 不支持视频下载。
- 评论功能可能不稳定。
- 某些设备调整倍速时可能掉帧。
- SponsorBlock 不能保证覆盖所有赞助片段。
- 全局语音搜索需要额外桥接应用，部分设备可能还涉及卸载官方客户端或 root，不属于开箱即用功能。
- 项目是个人维护的业余开源项目，不应按商业服务的支持响应来预期。

这些限制并不否定它的价值，但能帮助你判断：它适不适合成为家里电视的日常客户端。

## 七、谁适合尝试？

如果你使用 Android TV 或安卓盒子，希望获得更适合遥控器的浏览体验，并愿意接受 APK 侧载、开源项目更新节奏和必要的安全核验，SmartTube 是一个功能完整、社区关注度很高的选择。

如果你的电视运行 Tizen、webOS 或 VegaOS，或者你需要官方客服、稳定的评论功能和手机触屏体验，那么它并不适合。

一句话总结：SmartTube 不是“免费获得 YouTube Premium”的魔法工具，而是一款专门面向 Android TV、强调遥控器体验与播放控制的开源客户端。它的优势很明确，平台边界和安全注意事项也同样需要认真看待。

项目地址：https://github.com/yuliskov/SmartTube

官方页面：https://smarttubeapp.github.io

下载地址：https://github.com/yuliskov/SmartTube/releases/latest

---

更多内容欢迎关注公众号：

![公众号关注二维码](https://zmgo.oss-cn-shenzhen.aliyuncs.com/logo/qrcode_for_gh_de689d92e7f2_258.jpg)
