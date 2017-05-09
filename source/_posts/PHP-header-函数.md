---
title: PHP header()函数
date: 2016-04-24 23:43:27
description: "在php程序代码中，我们可以使用header()函数向http协议头写入头信息："
tags:
- php
---
在php程序代码中，我们可以使用header()函数向http协议头写入头信息：
```php
//控制跳转到新的页面 header("Location: 新的页面");
//控制浏览器间隔一定的时间去跳转，例子为3秒
header("Refresh: 3;url=http://localhost.com");
//通过header来禁用缓存（ajax），一共需要写入三个头消息
header("Rxpires: -1"); header("Cache-Control: no_cache"); header("Pragma: no_cache");
```
