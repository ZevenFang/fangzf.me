---
title: 免费影音播放器 Streambert：能追剧、看番，还能下载
date: 2026-05-22 11:27:27
description: "介绍免费开源影音播放器 Streambert：聚合电影、剧集、动漫、字幕、下载和资料库管理，并说明项目技术栈与合法使用边界。"
categories:
- 开源项目
tags:
- Streambert
- 影音播放器
- 开源
- Electron
---

![文章封面](/images/wechat-sync/streambert-free-video-player/cover_streambert.jpg "封面基于 README Trending 截图制作")

## 一、项目一句话介绍

Streambert 是一个开源的跨平台 Electron 桌面应用，项目 README 对它的定位是：用于串流和下载电影、剧集与动漫的桌面客户端，并强调“Zero Ads and Tracking”。

项目地址：https://github.com/truelockmc/streambert

从当前 README 和仓库信息看，Streambert 不是一个“内容平台”，更像是把影视检索、元数据、播放源解析、下载、字幕、库管理和界面自定义聚合到本地桌面端的应用。它采用 GPL-3.0 许可证，最新 Release 页面目前指向 2.4，仓库页面显示约 4.1k stars。

## 二、为什么值得看

README 里把核心卖点压缩成几组能力：串流、下载、字幕、可定制、资料库、趋势发现、隐私和速度。对一个桌面端项目来说，重点不只是“能看”，而是把用户在浏览器里分散完成的动作，集中进一个本地应用里。

![README 截图：Trending / 发现页](/images/wechat-sync/streambert-free-video-player/screenshots_trending.jpg "README 截图：Trending / 发现页")

它的产品思路比较清晰：

- 用桌面应用承载播放、下载和本地管理，减少浏览器插件和网页广告的干扰。
- 用 TMDB、AniList 等外部服务补齐封面、简介、搜索和分类信息。
- 针对电影、剧集和动漫分别处理数据来源和播放逻辑。
- 把下载、字幕和资料库做成应用内工作流，而不是让用户在多个工具之间切换。

## 三、从 README 截图看功能界面

### 1. 剧集与电影：按媒体类型组织体验

Streambert 不是只有一个搜索框。README 展示了剧集页和电影页，界面上更接近一个流媒体客户端：大图封面、标题信息、分区导航和内容卡片共同构成入口。

![README 截图：TV Series 页面](/images/wechat-sync/streambert-free-video-player/screenshots_series.jpg "README 截图：TV Series 页面")

![README 截图：Movie 页面](/images/wechat-sync/streambert-free-video-player/screenshots_movie.jpg "README 截图：Movie 页面")

这类设计的好处是，项目可以把“找内容”和“播放/管理内容”的路径统一起来：用户先通过元数据找到条目，再进入具体播放、下载、收藏或历史记录流程。

### 2. 动漫：单独接入 AniList 与 AllManga 逻辑

README 明确提到，应用会判断电影或剧集是否为动漫；如果是动漫，会使用 AniList 获取元数据，而不是只依赖 TMDB。媒体文件解析则来自 AllManga.to 相关机制，并且 README 提到该机制借鉴了 ani-cli。

![README 截图：Anime 页面](/images/wechat-sync/streambert-free-video-player/screenshots_anime.jpg "README 截图：Anime 页面")

从工程角度看，这是 Streambert 比普通影视壳子更复杂的地方：动漫生态的数据源、剧集结构、字幕需求和播放源都可能与普通影视不同，单独做适配能提升体验，但也意味着维护成本更高。

### 3. 无广告与追踪：这是项目的主张之一

README 把“Completely Ads and Tracker free, forever”列为核心卖点，并放了对应截图。对这类桌面端聚合应用来说，无广告和本地化体验是吸引用户的重要原因。

![README 截图：无广告与追踪统计](/images/wechat-sync/streambert-free-video-player/screenshots_adblock.jpg "README 截图：无广告与追踪统计")

需要注意的是，“无广告与追踪”并不等于内容来源没有任何风险。它更多是在应用体验层面减少广告、追踪和网页干扰；用户仍然需要确认自己访问内容的合法性。

## 四、可定制性：不只是播放器外壳

README 展示了自定义相关截图。Streambert 提供界面和功能层面的可配置能力，这让它更像一个“个人影音桌面环境”，而不是一次性播放工具。

![README 截图：Customize 设置一](/images/wechat-sync/streambert-free-video-player/screenshots_customize-1.jpg "README 截图：Customize 设置一")

![README 截图：Customize 设置二](/images/wechat-sync/streambert-free-video-player/screenshots_customize-2.jpg "README 截图：Customize 设置二")

对开源项目来说，可定制性还有另一个价值：它降低了分叉和二次开发门槛。用户偏好的布局、功能开关、下载目录、字幕方案，都可以通过设置层解决，而不是必须改源码。

## 五、字幕与下载：把“看完”变成完整工作流

README 中还强调了字幕下载和内容下载。字幕部分涉及字幕搜索、下载和管理；下载部分则依赖 m3u8 播放列表解析，并调用作者的另一个项目 vid-dl-cli-only 来完成下载，同时需要 ffmpeg。

![README 截图：字幕下载](/images/wechat-sync/streambert-free-video-player/screenshots_subs.jpg "README 截图：字幕下载")

![README 截图：下载功能](/images/wechat-sync/streambert-free-video-player/screenshots_download.jpg "README 截图：下载功能")

这说明 Streambert 的目标不是做一个简单网页封装，而是覆盖“发现—播放—下载—字幕—本地管理”的链路。README 里也写到，下载后的文件可以在应用内观看，也可以带到其他存储介质上。

## 六、技术栈与项目结构

从 package.json 和 README 的项目结构看，Streambert 主要由这些部分组成：

- 桌面框架：Electron。
- 前端框架：React 18。
- 构建工具：Vite。
- 打包工具：electron-builder。
- 平台产物：Windows 安装包、Linux deb / AppImage / pacman，脚本里也包含 macOS 打包目标。
- 元数据来源：TMDB、AniList。
- 播放/解析来源：README 提到 VidSrc、videasy.net、2Embed，以及动漫相关的 AllManga.to。
- 下载依赖：vid-dl-cli-only 与 ffmpeg。

项目目录也比较典型：src/components 放 UI 组件，src/pages 放页面，src/ipc 放 Electron 主进程侧的下载、字幕、播放、存储等 IPC 能力，src/utils 放 API、评分、备份、外观和本地存储等工具逻辑。

## 七、安装前需要知道什么

根据 README，使用 Streambert 前有几个关键前提：

- 如果不用预构建包，本地需要 Node.js 22.12.0 或以上。
- 首次启动需要填入免费的 TMDB API Read Access Token，应用会保存在本地。
- 如果要使用下载功能，需要安装 ffmpeg，并准备作者的 vid-dl-cli-only 程序。
- Linux 可以使用 deb、pacman 或 AppImage；Windows 下载最新的 Streambert Setup exe 安装包。

源码构建路径也很直接：npm install 后根据平台运行 npm run dist:win、npm run dist:linux、npm run dist:arch 或 npm run dist:appimage。

## 八、必须单独说的法律边界

README 在 Legal Disclaimer 里写得很明确：Streambert 不托管、不存储、不分发受版权保护内容；所有内容来自第三方提供方和网站；用户需要自行确保自己有合法权利访问相关内容，并遵守所在地法律。

这段声明很重要。介绍这类项目时，不能只看“功能强”，还要看边界：

- 它适合作为桌面应用、Electron IPC、媒体元数据聚合、字幕/下载工作流设计的开源案例来研究。
- 使用时应仅访问自己有权访问的内容。
- 对第三方内容源的稳定性、合规性和可用性，不应做过度假设。

## 九、适合谁关注

我觉得 Streambert 适合三类人看：

1. 想研究 Electron + React 桌面端产品结构的人。
2. 想了解影视元数据、字幕、下载和本地库管理如何串成一条产品链路的人。
3. 关注“无广告、少追踪、本地化体验”的开源桌面应用用户。

如果你只是想找一个“开箱即用且完全无依赖”的播放器，它可能不是最轻的选择；但如果你关注的是开源桌面端怎样整合复杂媒体工作流，Streambert 的 README 和项目结构都值得翻一翻。

## 十、总结

Streambert 的看点不在于单点技术多新，而在于它把多个原本分散的环节整合成了一个桌面应用：影视/动漫发现、元数据展示、播放、下载、字幕、库管理和界面定制。它的 README 也把法律边界写得比较清楚，这一点在介绍同类项目时尤其重要。

项目地址：https://github.com/truelockmc/streambert

---

更多内容欢迎关注公众号：

![公众号关注二维码](https://zmgo.oss-cn-shenzhen.aliyuncs.com/logo/qrcode_for_gh_de689d92e7f2_258.jpg)

