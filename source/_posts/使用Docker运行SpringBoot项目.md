---
title: 使用Docker运行SpringBoot项目
date: 2021-04-14 17:52:09
tags:
---
```sh
docker run --name demo-system -dp 8080:8080 --restart always -v `pwd`:/usr/jars openjdk:8 java -jar /usr/jars/demo-system.jar
```
再配合[Portainer](https://github.com/portainer/portainer)管理，轻松实现微服务部署
