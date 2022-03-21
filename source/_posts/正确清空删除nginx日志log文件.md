---
title: 正确清空删除nginx日志log文件
date: 2022-03-21 17:43:31
description: nginx日志如果不加限制，会把服务器空间写满，这时候如果直接rm删除log文件，磁盘空间不会直接释放。
tags: nginx
categories: Linux
---
nginx日志如果不加限制，会把服务器空间写满，这时候如果直接rm删除log文件，磁盘空间不会直接释放。

未释放磁盘空间原因：
在Linux或者Unix系统中，通过rm或者文件管理器删除文件将会从文件系统的目录结构上解除链接(unlink).然而如果文件是被打开的（有一个进程正在使用），那么进程将仍然可以读取该文件，磁盘空间也一直被占用。而我删除的是nginx的log文件删除的时候文件应该正在被使用。

解决方法：
重启`nginx`服务，或者用`echo "" > /usr/local/nginx/logs/access.log`清空日志文件，而不是直接删除。
`/usr/local/nginx`路径替换成实际的`nginx`路径。
该解决方法对其它应用产生的日志文件也有效

如果已经删除文件，`nginx -s reload`不会生效，需要：
```bash
nginx -s stop && nginx #重启nginx
```
