---
title: ufw防火墙命令
date: 2019-10-30 14:43:00
description: "使用ufw命令，快速监控设置防火墙"
tags: Linux
---

### 下载安装
* 下载地址：https://launchpad.net/ufw/
* 安装程序：
```sh
tar zxvf ufw-0.36.tar.gz
cd ufw-0.36
make
sudo make install
```

###  使用命令
* 开启ufw
```sh
ufw enable
ufw default deny
```
* 查看防火墙状态
```sh
ufw status 
```
* 开启/禁用相应端口或服务举例
```sh
ufw allow 80 # 允许外部访问80端口
ufw delete allow 80 # 禁止外部访问80端口
ufw allow from 192.168.1.1 # 允许此IP访问所有的本机端口
ufw deny smtp # 禁止外部访问smtp服务
ufw delete allow smtp # 删除上面建立的某条规则
ufw deny proto tcp from 10.0.0.0/8 to 192.168.0.1 port 22 # 要拒绝所有的TCP流量从10.0.0.0/8 到192.168.0.1地址的22端口
```
* 可以允许所有RFC1918网络（局域网/无线局域网的）访问这个主机（/8,/16,/12是一种网络分级）：
```
ufw allow from 10.0.0.0/8
ufw allow from 172.16.0.0/12
ufw allow from 192.168.0.0/16
```
