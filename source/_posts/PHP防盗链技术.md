---
title: PHP防盗链技术
date: 2016-04-24 23:39:35
description: "//通过获取http协议的消息头的REFERER来防盗链 if(isset($_SERVER['HTTP_REFERER'])){//判断REFERER是否为http://localhost开头的"
tags:
- php
---

```php
<?php
//通过获取http协议的消息头的REFERER来防盗链
if(isset($_SERVER['HTTP_REFERER'])){//判断REFERER是否为http://localhost开头的
    if(strpos($_SERVER['HTTP_REFERER'],"http://localhost"==0)){//非本网站访问全部封杀
        echo "本网站用户，可以或查看链接";
    }else{ //否则跳转到警告页面
        header("Location: warning.html");
    }
}else{//否则跳转到警告页面
    header("Location: warning.html");
}
?>
```
