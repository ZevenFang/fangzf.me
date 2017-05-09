---
title: 更新Github fork后的项目代码
date: 2017-03-17 11:52:41
description: "三步走：配置远程的upstream 地址，对upstream的代码更新，进行代码合并。"
tags:
- Githhub
---
### 1. 配置远程的upstream 地址
```shell
git remote add upstream https://github.com/ORIGINAL_OWNER/ORIGINAL_REPOSITORY.git
```
### 2. 对upstream的代码更新
```shell
git fetch upstream
```
### 3. 进行代码合并
```shell
git merge upstream/master
```
