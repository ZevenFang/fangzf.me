---
title: Gitlab出现502异常解决方法
date: 2018-10-28 12:46:40
description: "服务器重启后，访问gitlab出现502异常"
tags: git
---
服务器重启后，访问gitlab出现502异常，出现如下界面：
![502](https://gitlab.com/gitlab-org/gitlab-ce/uploads/4ec43910ae033d50398db0240bbddee1/502.PNG)

解决方法：
```sh
gitlab-ctl stop # 暂停gitlab
vim /etc/gitlab/gitlab.rb  # 修改gitlab配置
gitlab-ctl reconfigure # 重新生成配置
gitlab-ctl restart # 重启gitlab
```

以上列举了一些常用的命令，对于有时候服务器重启出现502异常，只需要运行`gitlab-ctl restart`重启一遍就好了
