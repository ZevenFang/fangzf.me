---
title: 使用Docker运行SpringBoot项目
date: 2021-04-14 17:52:09
tags:
---
### 基本命令
```sh
docker run --name demo-system -dp 8080:8080 --restart always -v `pwd`:/usr/jars openjdk:8 java -jar /usr/jars/demo-system.jar
docker run --name demo-system -dp 8080:8080 --restart always -v `pwd`:/usr/jars openjdk:8 java -Xmx1g -jar /usr/jars/demo-system.jar # 限制内存占用1G
```
### 定义函数命令
```sh
# --net=host，在多台主机部署，spring gateway 才能访问
function djar {
    docker run --net=host --name $1_$2 -d -e PORT=$2 --restart always -v `pwd`:/usr/jars openjdk:8 java -Xmx500m -jar -Duser.timezone=Asia/Shanghai /usr/jars/$1
}
# 调用函数
djar demo-system.jar 8080
```
再配合[Portainer](https://github.com/portainer/portainer)管理，轻松实现微服务部署
