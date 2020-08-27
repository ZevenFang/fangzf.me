---
title: Gradle 设置全局代理
date: 2020-08-15 20:25:23
categories:
- Android
---

```ini
org.gradle.jvmargs=-DsocksProxyHost=127.0.0.1 -DsocksProxyPort=1080 #socks5设置
systemProp.http.proxyHost=127.0.0.1 #http设置
systemProp.http.proxyPort=1086 #http设置
systemProp.https.proxyHost=127.0.0.1 #https设置
systemProp.https.proxyPort=1086 #https设置
```
