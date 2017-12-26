---
title: 部署 Meteor 应用到服务器
date: 2017-06-02 10:10:10
description: 这里介绍一种只使用 Meteor 自身的 build 命令，再加上 pm2 来部署 Meteor 应用的方法。不过最好你的本地开发电脑可以翻墙，这样安装 Meteor 和相关的 npm 包更顺畅。
tags:
- Meteor
categories:
- Backend
---
这里介绍一种只使用 Meteor 自身的 build 命令，再加上 pm2 来部署 Meteor 应用的方法。不过最好你的本地开发电脑可以翻墙，这样安装 Meteor 和相关的 npm 包更顺畅。
### 配置服务器
1. 安装 Node.js 稳定版，建议从源码编译安装
```bash
wget https://nodejs.org/dist/v6.10.3/node-v6.10.3.tar.gz
tar zxvf node-v6.10.3.tar.gz
cd node-v6.10.3
./configure
make # make 时间会比较长
sudo make install # 如果使用非 root 账号，需要加 sudo
node -v # 检查一下 nodejs 是否安装成功
```
2. 安装 MongoDB
MongoDB 官方的源在中国太慢，一般需要大概 3 个小时完成下载，推荐使用清华大学的源，[详细步骤见这里](https://mirror.tuna.tsinghua.edu.cn/help/mongodb/)
3. 安装 pm2
跟安装其他 npm 包类似，需要全局安装：
```bash
npm install pm2 -g
```
4. 代码文件夹
创建存放 Meteor build 打包成 Node.js app 后的源代码文件夹：
```bash
mkdir /home/meteor
mkdir /home/meteor/build
```

### 本地打包 Meteor App
假设你的 Meteor 源代码在你的本地开发电脑上一个叫 meteor-app 的文件夹里，我们在它的同级目录建立一个叫 build 的文件夹。然后运行
```bash
cd meteor-app
meteor build --architecture=os.linux.x86_64 ../build
scp ../build/meteor-build-test.tar.gz root@your.server.ip.address:/home/meteor/build
```
上面的命令就是把 Meteor app 打包成普通的 Node.js app，然后上传到我们之前在服务器上创建的文件夹里。

### 运行 Meteor App
1. 在服务器上进入 /home/meteor/build，然后运行：
```bash
tar xvf meteor-build-test.tar.gz # 解压
cd bundle/programs/server && npm install # 安装依赖
```
2. 回到 bundle 目录配置 pm.json
```json
cd bundle
vim pm.json
// 将以下代码写进 pm.json
{
  "apps": [{
    "name": "appName",
    "cwd": "/home/meteor/build/bundle",
    "script": "main.js",
    "env": {
      "NODE_ENV": "production",
      "WORKER_ID": "0",
      "PORT": "3000",
      "ROOT_URL": "http://your.server.ip.address",
      "MONGO_URL": "mongodb://localhost:27017/meteor",
      "MONGO_OPLOG_URL": "mongodb://localhost:27017/local",
      "HTTP_FORWARDED_COUNT": "1",
      "METEOR_SETTINGS": {}
    }
  }]
}
```
3. 最后运行 `pm2 start pm2.json` 命令, 你的 meteor 就运行在服务器上了, 输入 `http://your.server.ip.address:3000` 即可访问。