---
title: 使用killall指令来关闭进程
date: 2022-02-24 11:05:33
description: Linux killall 用于杀死一个进程，与 kill 不同的是它会杀死指定名字的所有进程。
categories: Linux
tags: Centos
---

Linux `killall` 用于杀死一个进程，与 `kill` 不同的是它会杀死指定名字的所有进程。
`kill` 命令杀死指定进程 `PID`，需要配合 `ps` 使用，而 `killall` 直接对进程对名字进行操作，更加方便。

### 安装
```
yum install -y psmisc
```

### 参数说明
```
Usage: killall [-Z 上下文] [-u 用户名] [ -eIgiqrvw ] [ -信号 ] 程序名...
       killall -l, --list
       killall -V, --version

  -e,--exact          进程需要和名字完全相符
  -I,--ignore-case    忽略大小写
  -g,--process-group  结束进程组
  -y,--younger-than   仅匹配指定时间之后的进程，与-o选项相反
  -o,--older-than     仅匹配指定时间之前（在指定时间之前开始）的进程。单位s、m、h、d、w（周）、M、y
  -i,--interactive    结束之前询问
  -l,--list           列出所有的信号名称
  -q,--quiet          进程没有结束时，不输出任何信息
  -r,--regexp         将进程名模式解释为扩展的正则表达式
  -s,--signal SIGNAL  发送指定信号
  -u,--user USER      结束指定用户的进程
  -v,--verbose        显示详细执行过程
  -V,--version        显示详细执行过程
  -w,--wait           等待所有的进程都结束
  -Z,--context 正则表达式 仅杀死含有指定上下文的进程
                          (必须在其他参数前使用)
```
