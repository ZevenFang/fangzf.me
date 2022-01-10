---
title: 使用ffplay播放音频
date: 2022-01-10 16:34:09
tags: ffmpeg
categories: Linux
---

```sh
sudo apt-get install ffmpeg # 安装ffmpeg后，自带ffplay
ffplay -nodisp -autoexit audio.aac
```

`nodisp`不输出视频，不弹出视频窗口
`autoexit`播放完成后，自动退出
