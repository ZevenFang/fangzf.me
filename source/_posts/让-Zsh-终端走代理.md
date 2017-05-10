---
title: 让 Zsh 终端走代理
date: 2017-05-08 15:20:42
description: 在 ~/.zshrc 配置文件中添加下面一段，以后使用的时候输入 proxy 打开代理模式，关闭代理时输入 noproxy 即可。
categories: 
- Mac
---
在 ~/.zshrc 配置文件中添加下面一段，以后使用的时候输入 proxy 打开代理模式，关闭代理时输入 noproxy 即可。

```shell
vim ~/.zshrc

# where proxy
proxy () {
  export http_proxy="http://127.0.0.1:8087"
  export https_proxy="http://127.0.0.1:8087"
  echo "HTTP Proxy on"
}

# where noproxy
noproxy () {
  unset http_proxy
  unset https_proxy
  echo "HTTP Proxy off"
}
```
由于本人使用 [XX-Net](https://github.com/XX-net/XX-Net) 作为代理，所以默认代理端口为8087，如果使用其他代理软件请注意修改端口。