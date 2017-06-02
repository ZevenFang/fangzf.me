---
title: 判断 iframe 是否加载完成
date: 2017-05-15 09:41:06
description: 利用 onload 事件来判断 iframe 是否加载完成
tags:
- 前端
categories:
- Front
---
利用 onload 事件来判断 iframe 是否加载完成：

```js
var iframe = document.createElement("iframe");
iframe.src = "http://www.planabc.net";

if (iframe.attachEvent){
    iframe.attachEvent("onload", function(){
        alert("Local iframe is now loaded.");
    });
} else {
    iframe.onload = function(){
        alert("Local iframe is now loaded.");
    };
}

document.body.appendChild(iframe);
```

PS：
[IE 支持 iframe 的 onload 事件][1]，不过是隐形的，需要通过 attachEvent 来注册。

[1]: http://msdn.microsoft.com/en-us/library/cc197055(VS.85).aspx