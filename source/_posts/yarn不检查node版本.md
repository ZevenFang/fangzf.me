---
title: yarn不检查node版本
date: 2021-12-17 16:49:39
categories:
- Front
tags:
- yarn
---

设置全局生效
```
yarn config set ignore-engines true
```

指定当前命令生效
```
yarn install --ignore-engines
```
