---
title: node 调用命令行程序
date: 2017-11-27 16:33:42
description: 每种语言都有自己的优势，互相结合起来各取所长程序执行起来效率更高或者说哪种实现方式较简单就用哪个，nodejs是利用子进程来调用系统命令或者文件。
tags:
- 前端
categories:
- Front
---
每种语言都有自己的优势，互相结合起来各取所长程序执行起来效率更高或者说哪种实现方式较简单就用哪个，nodejs是利用子进程来调用系统命令或者文件，文档见 http://nodejs.org/api/child_process.html ，NodeJS子进程提供了与系统交互的重要接口，其主要API有： 标准输入、标准输出及标准错误输出的接口。

```js
require("child_process").exec('adb reverse tcp:'+PORT+' tcp:'+PORT,
  function (error, stdout, stderr) {
    if (error === null)
      console.log('adb reverse success');
    else console.error('error: '+error);
  });
```