---
title: Nginx 配置 SSL 虚拟主机
date: 2017-12-22 14:07:45
description: 直接上代码，server 配置如下，同时支持 http 和 https 访问，另外还可以使用如下配置实现 http 重定向到 https。
tags:
- nginx
categories:
- Backend
---
直接上代码，server 配置如下，同时支持 http 和 https 访问：
```nginx
server {
    listen       80 default;     # 配置默认端口
    listen       443 ssl;          # 配置 ssl 端口
    server_name  your.server.name; # 配置解析域名

    ssl_certificate      /etc/letsencrypt/live/your.server.name/fullchain.pem; # 证书位置
    ssl_certificate_key  /etc/letsencrypt/live/your.server.name/privkey.pem;   # 私钥位置

    ssl_session_timeout  5m; 
    ssl_protocols  SSLv2 SSLv3 TLSv1; # 指定密码为openssl支持的格式 
    ssl_ciphers  HIGH:!aNULL:!MD5;    # 密码加密方式 
    ssl_prefer_server_ciphers   on;   # 依赖SSLv3和TLSv1协议的服务器密码将优先于客户端密码 

    # if ($server_port != 443) { # 通过判断端口，强制访问https
    #     rewrite (.*) https://$host$1 permanent;
    # }

    location / {
        root   html/your.server.name; # 根目录的相对位置 
        index  index.html index.htm;
    }

    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   html;
    }
}
```
另外还可以使用如下配置实现`http`重定向到`https`
```nginx
server {

    listen       80;
    server_name  your.server.name;

    #rewrite ^(.*) https://$server_name$1 permanent;
    rewrite ^(.*)$  https://$host$1 permanent;

}
server { 

    listen       443; # 监听端口为443 
    server_name  your.server.name;

    ssl                  on; # 开启ssl 
    ssl_certificate      /etc/letsencrypt/live/your.server.name/fullchain.pem;
    ssl_certificate_key  /etc/letsencrypt/live/your.server.name/privkey.pem;
    ssl_session_timeout  5m;
    ssl_protocols  SSLv2 SSLv3 TLSv1;
    ssl_ciphers  HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers   on;

    location / { 
        root   html/your.server.name;
        index  index.html index.htm; 
    }

}
```
