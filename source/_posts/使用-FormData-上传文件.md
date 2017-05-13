---
title: 使用 FormData 上传文件
date: 2017-05-13 21:49:37
description: 利用FormData对象,我们可以通过JavaScript用一些键值对来模拟一系列表单控件,我们还可以使用XMLHttpRequest的send()方法来异步的提交这个"表单".比起普通的ajax,使用FormData的最大优点就是我们可以异步上传一个二进制文件。
tags:
- 前端
categories:
- Front
---
> XMLHttpRequest Level 2添加了一个新的接口FormData.利用FormData对象,我们可以通过JavaScript用一些键值对来模拟一系列表单控件,我们还可以使用XMLHttpRequest的send()方法来异步的提交这个"表单".比起普通的ajax,使用FormData的最大优点就是我们可以异步上传一个二进制文件。 ——from [MDN](https://developer.mozilla.org/zh-CN/docs/Web/API/FormData)

简单的例子：
```js
function UploadFile() {
    var fileObj = document.getElementById("file").files[0]; // 获取文件对象
    var FileController = "../file/save";                    // 接收上传文件的后台地址 
    // FormData 对象
    var form = new FormData();
    form.append("author", "hooyes");                        // 可以增加表单数据
    form.append("file", fileObj);                           // 文件对象
    // XMLHttpRequest 对象
    var xhr = new XMLHttpRequest();
    xhr.open("post", FileController, true);
    xhr.onload = function () {
        alert("上传完成!");
    };
    xhr.send(form);
}
```