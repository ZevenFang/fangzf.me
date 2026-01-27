---
title: Window查找端口占用并杀掉占用的进程
date: 2026-01-27 10:00:00
tags: Windows
description: 记录如何在 Window 系统下查找端口占用情况，并强制结束占用端口的进程。
---

在开发过程中，经常遇到端口被占用的情况，导致服务无法启动。本文记录如何在 Window 系统下查找端口占用并杀掉占用的进程。

### 1. 查找占用端口的进程 ID (PID)

使用 `netstat` 命令查找占用特定端口的进程。

命令格式：
```bash
netstat -ano | findstr "<端口号>"
```

例如，查找占用 `3000` 端口的进程：

```bash
netstat -ano | findstr "3000"
```

输出示例：
```
  TCP    0.0.0.0:3000           0.0.0.0:0              LISTENING       50788
  TCP    [::]:3000              [::]:0                 LISTENING       50788
```

其中最后一列的数字 `50788` 就是进程 ID (PID)。

### 2. 查看进程名称（可选）

知道 PID 后，可以使用 `tasklist` 命令查看是哪个程序占用了该端口。

命令格式：
```bash
tasklist | findstr "<PID>"
```

例如：
```bash
tasklist | findstr "50788"
```

输出示例：
```
node.exe                     50788 Console                    1     91,772 K
```

可以看到是 `node.exe` 占用了 3000 端口。

### 3. 杀掉进程

使用 `taskkill` 命令强制结束进程。

命令格式：
```bash
taskkill /F /PID <PID>
```

例如：
```bash
taskkill /F /PID 50788
```

*   `/F` 参数表示强制结束进程。
*   `/PID` 参数指定要结束的进程 ID。

执行成功后，通常会提示：
```
成功: 已终止 PID 为 50788 的进程。
```

### 总结

完整的操作流程如下：

1.  `netstat -ano | findstr 3000`  -> 找到 PID
2.  `taskkill /F /PID <PID>` -> 杀掉进程

这样就可以释放被占用的端口了。
