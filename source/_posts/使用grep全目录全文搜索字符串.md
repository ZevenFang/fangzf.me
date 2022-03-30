---
title: 使用grep全目录全文搜索字符串
date: 2022-03-30 10:52:24
tags: bash
categories: Linux
---
搜索etc下面的文件，包含所有目录下的文件：
```bash
grep -lr 'string' /etc/
```
搜索当前目录下面的文件，不包含子目录下的文件：
```bash
grep -l 'string' .
```
-i，忽略大小写
-l，找出含有这个字符串的文件
-r，不放过子目录
