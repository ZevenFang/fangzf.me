---
title: 使用node-http-proxy代理调试接口
date: 2017-11-15 10:47:30
description: 前端开发中，经常会遇到跨域请求访问不到接口的问题，为了解决这个问题...
tags:
- 前端
categories:
- Front
---
前端开发中，经常会遇到跨域请求访问不到接口的问题，为了解决这个问题，我们可以让后端配置跨域。
或者前端配置代理，让我们自由访问接口。
```js
var httpProxy = require('http-proxy');
var host = 'https://your.target.host'; // 代理主机
const PORT = process.env.PORT || 9888; // 本地端口
var proxy = httpProxy.createProxyServer({
  target: host,
  changeOrigin: true, // 改变来源为当前主机
  secure: false // 信任不安全的证书
});
proxy.on('error', function (err, req, res) { // 自定义代理报错信息
  res.writeHead(500, {
    'Content-Type': 'text/plain'
  });
  res.end('Something went wrong. And we are reporting a custom error message.');
});
proxy.listen(PORT);
console.log("Proxy service is listening on port "+PORT);
```