---
title: centos安装mysql-community-devel
date: 2022-08-11 17:18:46
tags:
---

```bash
wget https://repo.mysql.com/yum/mysql-5.7-community/el/7/x86_64/mysql-community-common-5.7.39-1.el7.x86_64.rpm
wget https://repo.mysql.com/yum/mysql-5.7-community/el/7/x86_64/mysql-community-libs-5.7.39-1.el7.x86_64.rpm
wget https://repo.mysql.com/yum/mysql-5.7-community/el/7/x86_64/mysql-community-devel-5.7.39-1.el7.x86_64.rpm
rpm -ivh mysql-community-common-5.7.39-1.el7.x86_64.rpm
rpm -ivh mysql-community-libs-5.7.39-1.el7.x86_64.rpm
rpm -ivh mysql-community-devel-5.7.39-1.el7.x86_64.rpm
yum install -y mysql-community-devel
```
