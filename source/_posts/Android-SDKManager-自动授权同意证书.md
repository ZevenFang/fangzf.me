---
title: Android SDKManager 自动授权同意证书
date: 2020-06-06 16:49:10
tags: Android
description: 在运行 gradle 构建脚本时，经常会出现没有同意SDK证书，导致无法完成构建，可以通过以下几行命令自动同意证书
---

在运行`gradle`构建脚本时，经常会出现没有同意SDK证书，导致无法完成构建，可以通过以下几行命令自动同意证书

```bash
export ANDROID_HOME=/your/path/to/android/home
mkdir -p "$ANDROID_HOME/licenses"
echo -e "\n8933bad161af4178b1185d1a37fbf41ea5269c55" > "$ANDROID_HOME/licenses/android-sdk-license"
echo -e "\n84831b9409646a918e30573bab4c9c91346d8abd" > "$ANDROID_HOME/licenses/android-sdk-preview-license"
```
