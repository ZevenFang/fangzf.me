---
title: 利用docker快速在当前目录创建ftp账户
date: 2020-06-06 17:13:48
tags: docker
description: 使用docker-vsftpd镜像
---

### 创建FTP服务器
```bash
export ftpuser=username # FTP账户
export ftppass=password # FTP密码
export address=your.server.addr # FTP连接地址
docker run -d --name vsftpd-$ftpuser \
    -p 20001:21 -p 30001-30010:30001-30010 \
    -v `pwd`:/home/vsftpd/$ftpuser  \
    -e PASV_MIN_PORT=30001 \
    -e PASV_MAX_PORT=30010 \
    -e PASV_ADDRESS=$address \
    -e PASV_ADDR_RESOLVE=YES \
    -e FTP_USER=$ftpuser \
    -e FTP_PASS=$ftppass \
    -e FILE_OPEN_MODE=0777 \
    -e LOCAL_UMASK=022 \
    --restart=always zevenfang/vsftpd
```

### 连接FTP服务器
创建成功后，通过以下账户即可访问FTP：
```ini
地址：your.server.addr
端口：20001
用户名：username
密码：password
```
