---
title: 使用 Blob 下载文件流
date: 2017-05-16 00:07:51
description: 一个 Blob对象表示一个不可变的, 原始数据的类似文件对象。Blob表示的数据不一定是一个JavaScript原生格式。 File 接口基于Blob，继承 blob功能并将其扩展为支持用户系统上的文件。
tags:
- 前端
categories:
- Front
---
> 一个 Blob对象表示一个不可变的, 原始数据的类似文件对象。Blob表示的数据不一定是一个JavaScript原生格式。 File 接口基于Blob，继承 blob功能并将其扩展为支持用户系统上的文件。 ——from [MDN](https://developer.mozilla.org/zh-CN/docs/Web/API/Blob)

简单的例子：
```js
// 以下载Excel表格为例
api.exportData(ids).then(
  (res)=>{
    var blob = new Blob([res.data], {type: 'applicationnd.ms-excel'});
    var downloadUrl = URL.createObjectURL(blob);
    console.log(downloadUrl);
    var a = document.createElement("a");
    a.href = downloadUrl;
    a.download = "data.xlsx";
    document.body.appendChild(a);
    a.click();
  }
);
```