---
title: 使用openssl生成rsa私钥、公钥和证书
date: 2020-04-21 10:50:00
description: "三步走：产生私钥，产生公钥，生成证书"
categories: Linux
tags: Linux
---

```sh
openssl # 启动
OpenSSL> genrsa -out rsa_private_key.pem 2048 # 产生私钥
OpenSSL> rsa -in rsa_private_key.pem -pubout -out rsa_public_key.pem # 产生公钥
openssl req -new -key rsa_private_key.pem -out zeven.csr # 生成证书
```
