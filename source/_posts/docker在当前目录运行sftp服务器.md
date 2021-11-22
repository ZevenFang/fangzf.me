---
title: docker在当前目录运行sftp服务器
date: 2021-06-25 14:15:50
categories:
- Docker
tags:
- docker
---

### 一行代码启动
```bash
docker run --name my_sftp -v `pwd`:/home/foo -dp 2222:22 --restart always atmoz/sftp foo:pass:1001
```

### 连接FTP服务器
创建成功后，通过以下账户即可访问SFTP：
```ini
端口：2222
用户名：foo
密码：pass
```
