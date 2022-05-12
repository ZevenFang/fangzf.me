---
title: docker容器apache安装rewrite模块
date: 2022-05-12 12:27:19
categories: Docker
tags:
- docker
- apache
---

进入容器内部：
```bash
a2enmod rewrite # 安装模块
service apache2 restart # 重启容器
```

编辑`.htaccess`文件：
```xml
<IfModule mod_rewrite.c>
  Options +FollowSymlinks -Multiviews
  RewriteEngine On

  RewriteCond %{REQUEST_FILENAME} !-d
  RewriteCond %{REQUEST_FILENAME} !-f
  RewriteRule ^(.*)$ index.php/$1 [QSA,PT,L]

</IfModule>
```

查看是否开启成功：
执行`phpinfo()`函数，搜索`mod_rewrite`

使用镜像：
[zevenfang/docker-apache-php7](https://hub.docker.com/repository/docker/zevenfang/docker-apache-php7)
