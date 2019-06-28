---
title: Linux一行命令查找并杀掉进程
date: 2019-06-28 17:40:00
description: 查找并杀掉进程
tags: Android
---

```sh
ps -ef | grep redis | awk '{print $2}' | xargs kill -9
```
