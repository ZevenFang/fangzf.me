title: 使用 Chrome 调试 ReactNative 接口
date: 2017-06-13 10:18:22
tags:
- ReactNative

在入口文件中，将 Ajax 赋值到 GLOBAL 中：
```js
const _XHR = GLOBAL.originalXMLHttpRequest ?  
    GLOBAL.originalXMLHttpRequest :           
    GLOBAL.XMLHttpRequest                     

XMLHttpRequest = _XHR
```

优化版：
```js
GLOBAL.XMLHttpRequest = GLOBAL.originalXMLHttpRequest || GLOBAL.XMLHttpRequest;
```