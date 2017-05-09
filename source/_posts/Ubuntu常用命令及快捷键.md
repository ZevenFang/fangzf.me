---
title: Ubuntu常用命令及快捷键
date: 2016-04-25 15:48:15
description: "常用快捷键: Ctrl+Shift+T 打开terminal终端软件；Ctrl+Alt+F1 切换到第一个工作台；Ctrl+Alt+F7 切换到可视化工作台；Ctrl+D 退出终端打开的程序回到shell环境；Ctrl+L 清屏；Tab键可以自动补齐命令，两次tab键可以查看可补齐的内容"
tags:
- Ubuntu
categories:
- Linux
---
>Linux —— K.I.S.S.
>>Keep it simple,stupid!

### 常用快捷键
1. Ctrl+Shift+T 打开terminal终端软件
2. Ctrl+Alt+F1 切换到第一个工作台
3. Ctrl+Alt+F7 切换到可视化工作台
4. Ctrl+D 退出终端打开的程序回到shell环境
5. Ctrl+L 清屏
6. Tab键可以自动补齐命令，两次tab键可以查看可补齐的内容

### 常用命令
1. ls 列出当前目录内容
2. ls –l dir 查看一个目录下文件的操作权限
3. ls –ld dir 查看所在目录的操作权限
4. less 将命令行的内容分页查看，而不是一次性全部输出
5. ps aux|less 分页查看进程状态
6. mkdir 创建一个目录(eg: mkdir ttt)
7. rm 删除一个文件，但不能直接删除目录(eg: rm a.txt)
8. rm –r 添加-r参数可以删除目录
9. man+命令：打开某个命令的帮助，具体到某个参数的使用说明，/+参数即可查阅
10. 重定向（将shell输出到文本）
```php
echo 'hello' > hello.txt #标准输出
echo 'error' 2> error.txt #错误输出
echo 'world' >> hello.txt #向已有追加内容
```
11.   sudo 使用管理员权限执行命令(eg: sudo chmod 777 a.txt)
12.   chmod修改文件权限（实例说明）：
```php
chmod u+x file #给file的属主增加执行权限
chmod 751 file
#给file的属主分配读、写、执行(7)的权限，
#给file的所在组分配读、执行(5)的权限，
#给其他用户分配执行(1)的权限
chmod u=rwx,g=rx,o=x file #上例的另一种形式
chmod =r file #为所有用户分配读权限
chmod 444 file #同上例
chmod a-wx,a+r file #同上例
chmod -R u+r directory #递归地给directory目录下所有文件和子目录的属主分配读的权限
chmod 4755 #设置用ID，给属主分配读、写和执行权限，给组和其他用户分配读、执行的权限。
```
