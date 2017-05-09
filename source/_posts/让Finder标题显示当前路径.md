---
title: 让Finder标题显示当前路径
date: 2017-04-19 10:09:32
description: 很多情况下，我们都需要知道当前在那个目录，而 Mac 的资源管理器却默认不显示路径，开启的方法也很简单，只要在终端里输入以下命令：
categories: 
- Mac
---
很多情况下，我们都需要知道当前在那个目录，而 Mac 的资源管理器却默认不显示路径，开启的方法也很简单，只要在终端里输入以下命令：
```shell
defaults write com.apple.finder _FXShowPosixPathInTitle -bool YES killall Finder
```