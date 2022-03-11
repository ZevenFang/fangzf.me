---
title: CentOS安装VeryNginx
date: 2022-03-10 18:26:35
categories: Linux
tags:
- Centos
- nginx
---

### 安装步骤
```bash
yum install -y pcre-devel openssl openssl-devel #安装依赖
useradd nginx #添加nginx用户
git clone https://ghproxy.com/https://github.com/alexazhou/VeryNginx verynginx #下载
cd verynginx
python install.py install #安装
ln -s /opt/verynginx/openresty/nginx /root/server/nginx #目录软链接
ln -s /opt/verynginx/openresty/nginx/sbin/nginx /usr/bin/nginx #软链接
nginx #运行
nginx -s stop #停止
nginx -s reload #重载
```
