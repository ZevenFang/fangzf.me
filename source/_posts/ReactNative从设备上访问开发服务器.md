---
title: ReactNative从设备上访问开发服务器
date: 2016-06-22 23:55:50
description: 使用adb reverse命令,首先把你的设备通过USB数据线连接到电脑上，并开启USB调试，运行adb reverse tcp:8081 tcp:8081。不需要更多配置，你就可以使用Reload JS和其它的开发选项了。
tags:
  - React
  - ReactNative
categories:
  - Front
---
### Android 5.0及以上

使用adb reverse命令

1. 首先把你的设备通过USB数据线连接到电脑上，并开启USB调试。
2. 运行adb reverse tcp:8081 tcp:8081

不需要更多配置，你就可以使用Reload JS和其它的开发选项了。

### Android 5.0以下

通过Wi-Fi连接你的本地开发服务器
1. 首先确保你的电脑和手机设备在同一个Wi-Fi环境下。
2. 在设备上运行你的React Native应用。和打开其它App一样操作。
3. 你应该会看到一个“红屏”错误提示。这是正常的，下面的步骤会解决这个报错。
4. 摇晃设备，或者运行adb shell input keyevent 82，可以打开开发者菜单。
5. 点击进入Dev Settings。
6. 点击Debug server host for device。
7. 输入你电脑的IP地址和端口号（譬如10.0.1.1:8081）。
  - 在Mac上，你可以在系统设置/网络里找查询你的IP地址。
  - 在Windows上，打开命令提示符并输入ipconfig来查询你的IP地址。
  - 在Linux上你可以在终端中输入ifconfig来查询你的IP地址。
8. 回到开发者菜单然后选择Reload JS。
