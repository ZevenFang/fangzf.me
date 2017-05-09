---
title: 简易搭建mongodb
date: 2016-04-26 00:12:29
description: "mkdir mongodb 创建一个文件夹，cd mongodb 进入目录，mkdir data 创建存放数据的目录，mkdir log 创建日志文件的目录，mkdir conf 存放启动配置文件，mkdir bin 存放mongodb的二进制文件"
tags:
- mongodb
categories:
- Database
---
1.	mkdir mongodb 创建一个文件夹
2.	cd mongodb 进入目录
3.	mkdir data 创建存放数据的目录
4.	mkdir log 创建日志文件的目录
5.	mkdir conf 存放启动配置文件
6.	mkdir bin 存放mongodb的二进制文件
7.	cp mongo-r2.6.5/mongod mongodb/bin 将源二进制文件拷贝进bin目录
8.	vim conf/mongod.conf 编辑配置文件，写入以下配置：
```php
port = 12345
dbpath = data
logpath = log/mongod.log
fork = true
#fork在Linux下表明启动一个后台进程，在windows下则无效
```
9.	直接启动mongodb进程
```
bin/mongod –f conf/mongod.conf
```
10.	安全启动mongodb进程
```php
sudo cp mongo-r2.6.5/mongo /bin #将mongo客户端拷贝到/bin目录下
/bin/mongo 127.0.0.1:12345/test #连接并在本机创建一个test数据库
numactl --interleave=all bin/mongod –f conf/mongod.conf
```
11.	安装numactl
```php
sudo apt-get install numactl
#使用numactl安全启用mongodb服务，这样启动mongodb服务就不会出现警告。
```
13.	关闭mongodb服务, 使用killall mongod或者在client的shell里，use admin，执行db.shutdownServer()即可！
