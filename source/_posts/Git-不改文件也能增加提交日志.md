---
title: Git 不改文件也能增加提交日志：git commit --allow-empty
date: 2026-06-02 16:58:33
description: Git 可以通过空提交在不修改任何文件的情况下新增一条提交记录，适合触发 CI、补充发布节点或记录关键操作。
tags:
- Git
- CI/CD
- 开发技巧
categories:
- DevOps
---

平时我们说“提交代码”，默认都会想到先修改文件，然后 `git add`，最后 `git commit`。但 Git 其实允许创建一条不包含任何文件变更的提交记录，也就是空提交。

命令很简单：

```bash
git commit --allow-empty -m "对接域名安全接口"
```

这条命令不会修改任何文件，也不会把工作区里的内容凭空改掉，但会在 Git 历史里新增一条 commit 记录。

## 适用场景

空提交不是为了替代正常提交，它更适合这些场景：

- 触发 CI/CD 流水线
- 触发 GitHub Actions、GitLab CI、Webhook 等自动化任务
- 补充一条发布节点记录
- 记录一次没有文件变更但需要留痕的操作
- 重新跑一次部署流程

比如某个项目通过 GitHub push 自动部署，但代码内容没有变化，只想重新触发部署，就可以使用空提交。

## 基本用法

新增一条空提交：

```bash
git commit --allow-empty -m "触发重新部署"
```

查看提交记录：

```bash
git log --oneline -3
```

如果需要推送到远程仓库：

```bash
git push
```

推送后，远程仓库会收到新的 commit，因此依赖 push 触发的流水线也会正常执行。

## 和普通提交的区别

普通提交包含文件差异：

```bash
git status
git add .
git commit -m "修改页面样式"
```

空提交不包含文件差异：

```bash
git status
git commit --allow-empty -m "触发流水线"
```

所以空提交更像是“在 Git 历史里打一个点”，而不是提交实际代码。

## 使用前建议检查状态

创建空提交前，最好先看一下工作区状态：

```bash
git status --short
```

如果工作区有未提交改动，要确认这些改动是否应该一起提交。否则可以保持它们不动，只创建空提交：

```bash
git commit --allow-empty -m "补充操作日志"
```

这不会自动提交那些未暂存的文件。

## 注意事项

空提交虽然方便，但不要滥用。它会真实增加 Git 历史记录，如果只是本地临时测试，可以考虑是否真的需要 push 到远程。

比较推荐的提交信息写清楚目的，例如：

```bash
git commit --allow-empty -m "触发生产环境重新部署"
git commit --allow-empty -m "补充 2026-06-02 发布记录"
git commit --allow-empty -m "重新执行接口文档同步流水线"
```

这样之后看 Git 日志时，能明确知道这条没有文件变更的提交是为什么存在的。

## 总结

Git 空提交的核心命令就是：

```bash
git commit --allow-empty -m "提交说明"
```

它适合用来触发自动化流程或补充关键节点日志。只要提交信息写清楚，空提交就是一个很实用的小技巧。
