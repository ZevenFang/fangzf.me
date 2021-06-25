---
title: npm自动切换国内源
date: 2021-03-19 15:50:51
tags:
- 前端
categories:
- Front
---
```bash
npm --registry https://registry.npm.taobao.org i your-pack
npm i -g mirror-config-china --registry=https://registry.npm.taobao.org -f
```
