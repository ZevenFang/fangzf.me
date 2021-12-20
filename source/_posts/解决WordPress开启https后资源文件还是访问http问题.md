---
title: 解决WordPress开启https后资源文件还是访问http问题
date: 2021-02-01 18:14:52
description: 后台设置站点为https提示重复重定向，访问前台页面资源文件无法加载，只需要在config里面设置这几行代码即可
categories:
- Backend
tags:
- wordpress
---

```php
# 强制开启HTTPS
$_SERVER['HTTPS'] = 'on';
define('FORCE_SSL_LOGIN', true);
define('FORCE_SSL_ADMIN', true);
# 设置网站地址
define('WP_HOME','https://www.yoursite.com');
define('WP_SITEURL','https://www.yoursite.com');
```
