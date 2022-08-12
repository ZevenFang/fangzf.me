---
title: centos安装yate服务器
date: 2022-08-11 18:16:25
tags:
---

```bash
yum install -y gcc gcc-c++
wget https://zmgo.oss-cn-shenzhen.aliyuncs.com/public/server/yate6.tar.gz
tar -zxvf yate6.tar.gz
cd yate
./configure
make
./run -vvvvv -CDo #调试模式运行
./run -d #后台运行
```
