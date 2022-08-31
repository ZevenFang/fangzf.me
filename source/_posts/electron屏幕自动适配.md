---
title: electron屏幕自动适配
date: 2022-08-31 16:46:41
tags:
---

在前端代码里面添加：
```js
const devInnerWidth= 1920.0 // 开发时的InnerWidth
const zoomFactor =  window.innerWidth / devInnerWidth;
require('electron').webFrame.setZoomFactor(zoomFactor);
```
