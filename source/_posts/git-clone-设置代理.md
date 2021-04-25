---
title: git clone 设置临时代理
date: 2021-03-20 16:30:24
tags:
---

```sh
# 一次性代理
git clone -c http.proxy="http://127.0.0.1:1087" https://github.com/
# 全局设置代理
git config --global http.https://github.com.proxy socks5://127.0.0.1:1086
```
