---
title: yarn 国内加速镜像源
date: 2020-08-16 11:49:38
categories:
- Front
tags:
- yarn
---

```sh
npm install -g yarn --registry=https://registry.npm.taobao.org
yarn config set ignore-engines true #不检查node版本
yarn config set registry https://registry.npm.taobao.org --global
yarn config set disturl https://npm.taobao.org/dist --global
yarn config set sass_binary_site http://cdn.npm.taobao.org/dist/node-sass -g
```
