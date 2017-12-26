---
title: Nginx解决跨域请求
date: 2017-07-05 13:52:11
description: 在服务器端的nginx.conf中配置增加配置
tags:
- nginx
categories:
- Backend
---
在服务器端的nginx.conf中配置增加配置
```nginx
http {
  ......
  add_header Access-Control-Allow-Origin *;
  add_header Access-Control-Allow-Headers X-Requested-With;
  add_header Access-Control-Allow-Methods GET,POST,OPTIONS;
  ......
}
```