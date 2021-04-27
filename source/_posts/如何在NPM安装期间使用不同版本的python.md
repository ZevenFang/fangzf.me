---
title: 如何在NPM安装期间使用不同版本的python
date: 2021-02-27 09:33:57
tags:
---

```bash
# 修改npm参数
npm install --python=python2.7 # 使用--python选项
npm config set python python2.7 # 设置为默认使用
# 修改环境变量
export PYTHON=python2.7 # Linux
set PYTHON=python2.7 # Windows
```
