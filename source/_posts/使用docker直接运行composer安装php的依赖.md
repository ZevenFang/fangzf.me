---
title: 使用docker直接运行composer安装php的依赖
date: 2022-03-10 19:24:41
categories: Backend
tags: 
- docker
- php
---

```bash
docker run --rm --interactive --tty --volume $PWD:/app composer install
```
