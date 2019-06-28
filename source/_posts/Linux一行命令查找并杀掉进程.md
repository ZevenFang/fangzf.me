---
title: Linux一行命令查找并杀掉进程
date: 2019-06-28 17:40:00
description: 查找并杀掉进程
tags: Linux
---

```sh
ps -ef | grep redis | grep -v grep | awk '{print $2}' | xargs kill -9
```
grep 查询并显示 -v 是不包括
