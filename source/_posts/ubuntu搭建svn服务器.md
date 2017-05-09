---
title: ubuntu搭建svn服务器
date: 2016-05-02 22:29:03
description: "安装SVN apt-get install subversion 建立svn仓库 svnadmin create /home/.svn/zeven"
categories:
- Linux
tags:
- Ubuntu
- svn
---
1. 安装SVN
  ```shell
  apt-get install subversion
  ```
2. 建立svn仓库
    ```shell
    mkdir /home/.svn #使用隐藏目录建立svn目录
    cd /home/.svn
    mkdir zeven #创建仓库目录
    svnadmin create /home/.svn/zeven #初始化目录为svn仓库
    #执行完毕后zeven目录有svnadmin创建的目录和文件
    ```
3. 配置和管理svn

  - 每个仓库的配置文件在$repos/conf/下，vi svnserve.conf，配置项在[general]下:
  ```
  anon-access：匿名用户的权限，可以为read，write和none，默认值read。不允许匿名用户访问设置为none
  auth-access：认证用户的权限，可以为read，write和none，默认值write。
  password-db：密码数据库的路径，去掉前边的#
  authz-db：认证规则库的路径，去掉前边的#。
  注意：这些配置项的行都要顶格，否则会报错。修改配置后需要重启svn才能生效。
  ```
  - 配置passwd文件

        这是每个用户的密码文件，比较简单，就是“用户名=密码”，采用的是明码。如fang=123456

4. 设置权限，配置authz文件

  - [groups] section：为了便于管理，可以将一些用户放到一个组里边，比如：owner=zeven,fang

  - groups下边的sections表示对一个目录的认证规则，比如对根目录的认证规则的section为[/]。设置单用户的认证规则时一个用户一行，如：
  ```shell
[/]
allen=rw　　#allen对根目录的权限为rw
ellen=r　　  #ellen对根目录的权限为r
#如果使用group，需要在group名字前加@,如
@owner=rw　　#group owner中的用户均为rw，等价于上边的两句话
  ```
  - 启动时如果从/home/.svn/astar启动，/就是astar目录，用如上方式以astar目录为根设置权限。

  - 如果从/home/.svn/启动，每个仓库根还是自己的起始目录。可以采用如上方式设置astar的权限，也可以采用如下方式：
  ```shell
  [astar:/]
  @owner=rw
  #设置test的权限如下：
  [test:/]
  @harry_and_sally = rw
  ```
  - 简言之，每个仓库的根目录(/)就是自己的起始目录；[repos:/]这种方式只适用于多仓库的情况；[/]适合于单仓库和单仓库的方式，不能跨越仓库设置权限。
