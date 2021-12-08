---
title: 苹果mac近期TNT破解软件“意外退出”解决方案
date: 2021-12-08 11:17:14
categories:
- Mac
tags:
- xcode
---
```sh
# name替换成你无法打开的软件名，例如 DaisyDisk.app
codesign --force --deep --sign - /Applications/name.app
# 软件后缀有空格的软件需要用 \ 替换空格，例如：CleanMyMac X   →  CleanMyMac\ X
codesign --force --deep --sign - /Applications/CleanMyMac\ X.app
```
