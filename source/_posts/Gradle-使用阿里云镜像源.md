---
title: Gradle 使用阿里云镜像源
date: 2020-08-27 17:03:14
description: 设置阿里云镜像源，提高gradle下载依赖速度
categories:
- Android
---

```java
// Top-level build file where you can add configuration options common to all sub-projects/modules.

buildscript {
    repositories {
        // 插入阿里云镜像源
        maven{ url 'http://maven.aliyun.com/nexus/content/groups/public/'}
        jcenter()
        maven {
            url 'https://maven.google.com/'
            name 'Google'
        }
        google()
    }
    dependencies {
        classpath 'com.android.tools.build:gradle:3.3.2'

        // NOTE: Do not place your application dependencies here; they belong
        // in the individual module build.gradle files
    }
}

allprojects {
    repositories {
        // 插入阿里云镜像源
        maven{ url 'http://maven.aliyun.com/nexus/content/groups/public/'}
        jcenter()
        maven {
            url 'https://maven.google.com/'
            name 'Google'
        }
    }
}

task clean(type: Delete) {
    delete rootProject.buildDir
}
```
