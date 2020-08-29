---
title: Gradle 设置全局代理
date: 2020-08-15 20:25:23
categories:
- Android
---

以下配置使用Mac上shadowsocks默认设置：

```ini
org.gradle.jvmargs=-DsocksProxyHost=127.0.0.1 -DsocksProxyPort=1086 -DsocksNonProxyHosts=*.aliyun.com #socks5设置
systemProp.http.nonProxyHosts=*.aliyun.com #阿里云镜像源不需要代理
systemProp.http.proxyHost=127.0.0.1 #http设置
systemProp.http.proxyPort=1087 #http设置
systemProp.https.nonProxyHosts=*.aliyun.com #阿里云镜像源不需要代理
systemProp.https.proxyHost=127.0.0.1 #https设置
systemProp.https.proxyPort=1087 #https设置
```
