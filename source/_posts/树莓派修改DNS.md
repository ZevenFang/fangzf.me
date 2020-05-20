---
title: 树莓派修改DNS
date: 2020-05-20 14:41:23
description: "树莓派提示域名解析错误，可能是路由器的DNS设置异常了，这时候可以直接修改树莓派的DNS，不通过路由器解析域名，重启树莓派也能生效"
categories: Raspberry
---

树莓派提示域名解析错误，可能是路由器的DNS设置异常了，这时候可以直接修改树莓派的DNS，不通过路由器解析域名，重启树莓派也能生效

* 修改dns设置：

```sh
sudo vim /etc/dhcpcd.conf
```

* 设置文件添加一行配置

```ini
# 使用阿里云DNS
static domain_name_servers=223.5.5.5 223.6.6.6
```

* 最后重启dhcp服务

```sh
sudo service dhcpcd restart
```

* 测试一下，重启树莓派，也能生效

```sh
sudo reboot
```
