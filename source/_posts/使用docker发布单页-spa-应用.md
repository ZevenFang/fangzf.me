---
title: 使用docker发布单页(spa)应用
date: 2021-04-27 14:25:59
tags:
---
```
docker run --name your-app-name -dp 8000:80 --restart always -v `pwd`:/app zevenfang/nginx-spa
```
