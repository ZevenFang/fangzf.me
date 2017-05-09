---
title: 连接Redux调试服务器
date: 2016-08-21 10:10:21
description: 检查设备是否成功连接，运行adb devices；检查5678端口是否被占用；运行adb reverse tcp:5678 tcp:5678；摇晃设备，或者运行adb shell input keyevent 82，可以打开开发者菜单
tags:
  - React
  - ReactNative
categories:
  - Front
---

1. 检查设备是否成功连接，运行adb devices
2. 检查5678端口是否被占用
3. 运行adb reverse tcp:5678 tcp:5678
4. 摇晃设备，或者运行adb shell input keyevent 82，可以打开开发者菜单
5. 点击Debug JS Remote即可连接Redux调试服务器
