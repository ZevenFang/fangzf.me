---
title: Base64 转 文件下载
date: 2018-11-21 20:38:00
description: "将base64字符串转化为文件"
tags: html5
categories: Front
---

1. 将下面代码另存为html文件
2. 用浏览器打开
3. 点击下载

代码如下：
```html
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <meta charset="utf-8" />
</head>
<body>
    <div>输入base64字符串</div>
    <textarea id="base64text" rows="10" cols="40"></textarea>
    <div>输入文件名</div>
    <input id="filename" /><br />
    <button id="btnGenerate">下载</button><br />
    <a id="btnDownload"></a>
    <script>
        var base64text = document.getElementById("base64text");
        var filename = document.getElementById("filename")
        var btnGenerate = document.getElementById("btnGenerate");
        var btnDownload = document.getElementById("btnDownload");
 
        var MIME = {
            "application/x-zip-compressed": "zip",
            "application/javascript": "js",
            "text/css": "css",
            "text/plain": "txt",
            "text/html": "html",
            "text/xml": "xml",
            "image/jpeg": "jpeg",
            "image/png": "png",
            "image/gif": "gif",
            "image/svg+xml": "svg"
        };
 
        //文件名默认当前时间戳
        filename.value = Date.now();
 
        //检测点击下载按钮
        btnGenerate.addEventListener("click", function (e) {
            var fname = filename.value + "." + MIME[getContentType(base64text.value)];
            var blob = getBlob(base64text.value);
 
            if (navigator.msSaveBlob) {
                navigator.msSaveBlob(blob, fname);
            }
            else {
                btnDownload.download = fname;
                btnDownload.href = URL.createObjectURL(blob);
                btnDownload.click();
            }
        });
 
        /**
         * 获取Blob
         * @param {stirng} base64
         */
        function getBlob(base64) {
            return b64toBlob(getData(base64), getContentType(base64));
        }
 
        /**
         * 获取文件类型
         * @param {string} base64
         */
        function getContentType(base64) {
            return /data:([^;]*);/i.exec(base64)[1];
        }
 
        /**
         * 获取base64中的数据
         * @param {string} base64
         */
        function getData(base64) {
            return base64.substr(base64.indexOf("base64,") + 7, base64.length);
        }
 
        /**
         * base64转Blob
         * @param {string} b64Data
         * @param {string} contentType
         * @param {number} sliceSize
         */
        function b64toBlob(b64Data, contentType, sliceSize) {
            contentType = contentType || '';
            sliceSize = sliceSize || 512;
 
            var byteCharacters = atob(b64Data);
            var byteArrays = [];
 
            for (var offset = 0; offset < byteCharacters.length; offset += sliceSize) {
                var slice = byteCharacters.slice(offset, offset + sliceSize);
 
                var byteNumbers = new Array(slice.length);
                for (var i = 0; i < slice.length; i++) {
                    byteNumbers[i] = slice.charCodeAt(i);
                }
 
                var byteArray = new Uint8Array(byteNumbers);
 
                byteArrays.push(byteArray);
            }
 
            var blob = new Blob(byteArrays, { type: contentType });
            return blob;
        }
    </script>
</body>
</html>
```
演示地址：[base64ToFile](http://fangzf.me/html/base64ToFile.html)
