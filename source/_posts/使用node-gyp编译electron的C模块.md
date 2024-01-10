---
title: 使用node-gyp编译electron的C模块
date: 2024-01-10 10:44:59
categories:
- Front
tags:
- Electron
---

在对应模块下运行：
```bash
node-gyp rebuild --target=25.9.7 --arch=ia32 --dist-url=https://electronjs.org/headers
```
`target`换成对应的Electron版本
