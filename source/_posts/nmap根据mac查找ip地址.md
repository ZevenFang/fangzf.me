---
title: nmap根据mac查找ip地址
date: 2021-04-27 10:54:07
tags:
---
```sh
sudo nmap -sn 192.168.88.0/24 | grep -B2 00:E0:4C:7E:4C:F4
```
