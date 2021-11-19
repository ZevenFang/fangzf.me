---
title: JeecgBoot下拉搜索框异步加载数据
date: 2021-11-16 17:48:11
description: JeecgBoot当数据量非常大的时候，下拉搜索框会一次性带出所有数据，导致前端页面卡死，解决办法如下
categories:
- Backend
tags:
- SpringBoot
- JeecgBoot
---

JeecgBoot当数据量非常大的时候，下拉搜索框会一次性带出所有数据，导致前端页面卡死，解决办法如下：

1. 打开前端项目，找到下拉搜索组件，路径：src/components/dict/JSearchSelectTag.vue
2. 将`props`里面的参数`async: Boolean`改成`async: {type:Boolean,default:true}`
3. 重新编译打包后发布到生产，系统内所有的在线生成的表单下拉搜索组件会变成异步加载。
