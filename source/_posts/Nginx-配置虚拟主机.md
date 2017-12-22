---
title: Nginx 配置虚拟主机
date: 2017-12-22 14:07:45
description: 直接上代码，server 配置如下
tags:
- nginx
categories:
- Backend
---
直接上代码，server 配置如下
```sh
server {
    listen       7000 default; # 配置默认端口
    listen       443 ssl; # 配置 ssl 端口
    server_name  your.server.name; # 配置解析域名

    ssl_certificate      /etc/letsencrypt/live/your.server.name/fullchain.pem;
    ssl_certificate_key  /etc/letsencrypt/live/your.server.name/privkey.pem;

    location / {
        root   html/your.server.name;
        index  index.html index.htm;
    }

    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   html;
    }
}
```