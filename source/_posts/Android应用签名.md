---
title: Android应用签名
date: 2016-12-21 10:07:40
description: "三步走：生成密钥，签名apk，优化APK"
tags: Android
---

### 生成密钥
```
keytool -genkey -v -keystore app-release-key.keystore -alias app-release-key.keystore -keyalg RSA -keysize 2048 -validity 10000
```
### 签名apk
```
jarsigner -verbose -sigalg SHA256withRSA -tsa https://timestamp.geotrust.com/tsa -digestalg SHA1 -keystore app-release-key.keystore app-release-unsigned.apk app-release-key.keystore
```
### 优化APK
```
zipalign -v 4 app-release-unsigned.apk app-1.0.0.apk
```
