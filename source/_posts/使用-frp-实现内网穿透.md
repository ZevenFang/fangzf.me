---
title: 使用 frp 实现内网穿透
date: 2017-12-16 15:31:21
description: 开发过程中，可能会遇到接入第三方平台时，比如微信公众平台，需要提供公网的 IP 地址或域名的情况。大多数情况下，个人用户的网络是处在局域网中，并且线路无法提供公网的 IP。为了方便调试，这时候就需要通过内网穿透将本地的端口映射到公网上。
categories:
- Backend
---
开发过程中，可能会遇到接入第三方平台时，比如微信公众平台，需要提供公网的 IP 地址或域名的情况。
大多数情况下，个人用户的网络是处在局域网中，并且线路无法提供公网的 IP。
为了方便调试，这时候就需要通过内网穿透将本地的端口映射到公网上。
本篇文章将介绍通过 frp 将本地的 http 服务映射到公网上。
### frp 介绍
> frp 是一个可用于内网穿透的高性能的反向代理应用，支持 tcp, udp, http, https 协议。

文档地址：https://github.com/fatedier/frp/blob/master/README_zh.md
下载地址：https://github.com/fatedier/frp/releases

### 服务端
1. 配置 `frps.ini` 文件
```ini
[common]
bind_port = 7000 # frp 代理端口
vhost_http_port = 80 # http 服务端口
vhost_https_port = 443 # https 服务端口
dashboard_port = 7500 # 开启控制台端口，如果不设置 dashboard_user，默认为 admin
dashboard_user = username # 控制台用户名
dashboard_pwd = password # 控制台密码
```
2. 运行 frp 服务端
```sh
./frps -c ./frps.ini
```

### 客户端
1. 配置 `frpc.ini` 文件
    ```ini
    [common]
    server_addr = your.server.ip.address # 服务端公网 ip 地址
    server_port = 7000 # 与服务端配置的 bind_port 一致

    [web]
    type = http # 支持 http 和 https
    local_port = 80 # 本地映射端口
    custom_domains = your.server.name # 自定义域名，需要A解析到 server_addr
    ```
2. 运行 frp 客户端
```sh
./frpc -c ./frpc.ini
```

### 访问地址
在做完以上配置之后，即可访问本地穿透的服务：
* 直接通过 your.server.ip.address 或 your.server.name 访问本地的 http 服务
* 访问 your.server.ip.address:7500 或 your.server.name:7500 访问 frp 控制台
