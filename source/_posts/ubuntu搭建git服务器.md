---
title: ubuntu搭建git服务器
date: 2016-04-24 17:12:31
description: "服务器操作：安装git，apt-get install git；创建git用户和git用户组，分配目录/home/git，然后:；在/home/git下创建.ssh文件夹；在.ssh下创建authorized_keys文件，如果无效查看/etc/ssh/sshd_config文件一行：（AuthorizedKeysFile      %h/.ssh/authorized_keys）有没有被注释掉，重启ssh服务，service ssh restart"
categories:
- Linux
tags:
- Ubuntu
- git
---
### 服务器操作

1. 安装git，apt-get install git

2. 创建git用户和git用户组，分配目录/home/git，然后:
   ```
   $ vim /etc/passwd
   ```
   将：git:x:1003:1003::/home/git:
   改成：git:x:1003:1003::/home/git:/usr/bin/git-shell
   禁用git用户的shell

3. 在/home/git下创建.ssh文件夹

4. 在.ssh下创建authorized_keys文件，如果无效查看/etc/ssh/sshd_config文件一行：（AuthorizedKeysFile      %h/.ssh/authorized_keys）有没有被注释掉，重启ssh服务，service ssh restart

### 客户端操作

5. 配置git用户信息
	  ```
  $ git config --global user.name=username
  $ git config --alobal user.email=user@domain.com
    ```

6. 使用keygen在客户端生成公钥，命令如下：
    ```
    $ ssh-keygen -t rsa
    ```
    剩下按提示走（一般询问三次，1.公钥存放地址，2.设置密码，3.重复设置的密码）

### 服务器操作

7. 将生成的id_rsa.pub上传到服务器上，然后将内容粘贴到authorized_keys文件中，不要采用记事本打开，使用命令cat id_rsa.pub >>authorized_keys

8. 在/home/git目录下，创建仓库sample.git：
    ```
    $ git init --bare sample.git
    ```
    别忘了授予git拥有目录的权限，否则push代码时候会报没写入权限的错
    ```
    $ chown -R git:git sample.git
    ```

### 客户端操作

9. 测试是否成功连接上git server
	 ```
   $ ssh -T git@hostname:sample.git
   ```
   如果有Welcome什么的就是成功了，但是没法使用bash

10. 可以克隆git仓库到本地啦，运行：
    ```
    $ git clone git@hostname:sample.git
    ```
    会询问一次第6步设置的密码，成功校验就可以clone成功！
