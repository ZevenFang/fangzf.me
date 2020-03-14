---
title: chromium-browser常用命令
date: 2020-03-14 10:00:00
description: "chromium-browser常用参数和解释"
tags: Front
---

### 运行命令：
```sh
chromium-browser
--remote-debugging-port=9000 # 远程Debug调试
--user-data-dir=/home/user/.cache/chromium/Default/MyCache # 指定缓存目录
--disk-cache-dir=/dev/null --disk-cache-size=1 # 禁止缓存
--disable-web-security # 允许在https下调用http的接口
--allow-running-insecure-content # 允许在https下加载http的静态资源
--disable-popup-blocking # 禁止弹窗
--no-first-run # 跳过首次运行检测
--disable-desktop-notifications # 禁止桌面通知
--check-for-update-interval=31104000 # 禁止检查更新
--kiosk # 独占模式，要按CTRL+F4，才能退出
--app="http://192.168.1.88:8888/" # app模式，可以屏蔽异常退出的崩溃提示
--unsafely-treat-insecure-origin-as-secure="http://192.168.1.88:8888/"
# 指定地址无视安全策略，用于测试麦克风摄像头等需要无视https的场景
```

### 远程调试：
```sh
ssh user@192.168.1.88 -L 9000:localhost:9001
```
本地访问`http://localhost:9001`即可远程调试
