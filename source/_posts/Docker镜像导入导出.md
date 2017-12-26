---
title: Docker镜像导入导出
date: 2017-06-28 14:06:13
description: 导出容器快照到本地文件 docker export，从容器快照文件中再导入为镜像 docker import，通过指定 URL 或者某个目录来导入
categories:
- Docker
---

### 导出容器docker export
导出容器快照到本地文件
```bash
$ sudo docker ps -a
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS                    PORTS               NAMES
7691a814370e        ubuntu:14.04        "/bin/bash"         36 hours ago        Exited (0) 21 hours ago                       test
$ sudo docker export 7691a814370e > ubuntu.tar
```

### 导入容器快照docker import
从容器快照文件中再导入为镜像
```bash
$ cat ubuntu.tar | sudo docker import - test/ubuntu:v1.0
$ sudo docker images
REPOSITORY          TAG                 IMAGE ID            CREATED              VIRTUAL SIZE
test/ubuntu         v1.0                9d37a6082e97        About a minute ago   171.3 MB
```

### 通过指定 URL 或者某个目录来导入
导入远程的包:This will create a new untagged image.
```bash
sudo docker import http://example.com/exampleimage.tgz
```
导入本地文件:Import to docker via pipe and STDIN.
```bash
cat exampleimage.tgz | sudo docker import- exampleimagelocal:new
```
导入本地目录:
```bash
sudo tar -c dir/| sudo docker import - docker-image-name
```

PS: 用户既可以使用 docker load 来导入镜像存储文件到本地镜像库，也可以使用 docker import 来导入一个容器快照到本地镜像库。这两者的区别在于容器快照文件将丢弃所有的历史记录和元数据信息（即仅保存容器当时的快照状态），而镜像存储文件将保存完整记录，体积也要大。此外，从容器快照文件导入时可以重新指定标签等元数据信息。