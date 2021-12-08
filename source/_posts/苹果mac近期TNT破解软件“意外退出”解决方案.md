---
title: 苹果mac近期TNT破解软件“意外退出”解决方案
date: 2021-12-08 11:17:14
description: Apple删除了TNT的证书，因此诸多应用程序将在2019年7月12日之后崩溃，出现“意外退出”，无法打开的情况。
categories:
- Mac
tags:
- xcode
---

### 原因分析
Apple删除了TNT的证书，因此诸多应用程序将在2019年7月12日之后崩溃，出现“意外退出”，无法打开的情况。

### 解决方案
使用`codesign`自己签名

### 命令行代码
```bash
# 终端中安装xcode小开发工具，如果已经安装可跳过
xcode-select --install
# name替换成你无法打开的软件名，例如 DaisyDisk.app
codesign --force --deep --sign - /Applications/name.app
# 软件后缀有空格的软件需要用 \ 替换空格，例如：CleanMyMac X   →  CleanMyMac\ X
codesign --force --deep --sign - /Applications/CleanMyMac\ X.app
```
