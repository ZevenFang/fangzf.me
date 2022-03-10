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
yum install -y pcre-devel openssl openssl-devel # 安装依赖
git clone https://ghproxy.com/https://github.com/alexazhou/VeryNginx verynginx #下载
cd verynginx
python install.py install
```
