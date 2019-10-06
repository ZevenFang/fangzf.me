---
title: 开启Android无线ADB
date: 2019-10-06 16:00:00
description: "此方法无需手机ROOT，就可以实现无线ADB，首先将手机通过USB连接上电脑，运行以下命令："
tags: Android
---

此方法无需手机ROOT，就可以实现无线ADB，首先将手机通过USB连接上电脑，运行以下命令：
```sh
adb tcpip 5555 # 打开设备ADB端口
adb connect DEVICE_IP:5555 # 连接设备，将DEVICE_IP替换成相应的IP
```
最后拔掉USB数据线，就可以启用无线ADB了
