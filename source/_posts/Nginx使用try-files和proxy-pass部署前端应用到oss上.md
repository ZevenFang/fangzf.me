---
title: Nginx使用try_files和proxy_pass部署前端应用到oss上
date: 2021-04-30 11:08:28
description: 部署前端到oss上,既方便通过oss的sdk发布版本，又大大提高访问速度，减少服务器带宽压力
tags:
- nginx
categories:
- Backend
---

部署前端到oss上,既方便通过oss的sdk发布版本，又大大提高访问速度，减少服务器带宽压力
### nginx.conf 配置
```conf
worker_processes  1;

events {
    worker_connections  1024;
}

http {
    include       mime.types;
    default_type  application/octet-stream;
    sendfile        on;
    keepalive_timeout  65;

    server {
        listen       80;
        server_name  localhost;

        location /deploy/path {
            try_files $uri @redirect;
        }

        location @redirect {
            rewrite ^ /oss/path/index.html break;
            proxy_pass http://your-bucket.oss-cn-shenzhen-internal.aliyuncs.com;
        }
    }
}
```
### 运行服务
使用docker运行
```bash
docker run --restart always --name your-app-name -v `pwd`/nginx.conf:/etc/nginx/nginx.conf:ro -dp 3000:80 nginx
```
