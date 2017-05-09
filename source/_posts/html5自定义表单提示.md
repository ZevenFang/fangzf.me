---
title: html5自定义表单提示
date: 2016-04-24 23:57:06
description: "html5是目前最新版的超文本标记语言，结合了javascript/css/html使得标签功能更加强大，下面介绍html5自定义表单提示："
tags:
- html5
categories:
- Front
---
html5是目前最新版的超文本标记语言，结合了javascript/css/html使得标签功能更加强大，下面介绍html5自定义表单提示：
```html
<form name="passwordChange">
    <p>
        <label for="password1">New Password:</label>
        <input type="password" id="password1" onchange="checkPasswords()">
    </p>
    <p>
        <label for="password2">Confirm Password:</label>
        <input type="password" id="password2" onchange="checkPasswords()">
    </p>
</form>
<button onclick="document.passwordChange.password1.checkValidity()">Check Validity</button>
<script>
    function checkPasswords() {
        var pass1 = document.getElementById("password1");
        var pass2 = document.getElementById("password2");
        if (pass1.value != pass2.value)
            pass1.setCustomValidity("两次输入的密码不匹配");
        else
            pass1.setCustomValidity("");
</script>
```
