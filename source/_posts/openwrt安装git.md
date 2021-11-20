---
title: openwrt安装git
date: 2021-05-11 08:44:34
description: "Openwrt默认没有安装Git，自带的ssh没有ssh-agent功能，可以通过如下命令配置："
categories:
- Git
tags:
- git
---

Openwrt默认没有安装Git，自带的ssh没有ssh-agent功能，可以通过如下命令配置：

```bash
opkg update
# 安装Git
opkg remove git
opkg install git-http
opkg install ca-bundle
# 安装SSH
opkg install openssh-client openssh-keygen openssh-sftp-server
```
