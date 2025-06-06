---
title: 使用F12控制台操作Vue项目的Pinia对象数据
date: 2025-06-06 14:58:35
categories: Front
tags: 
- vue
- pinia
---

参考代码：
```js
function findOrg(name) {
    var app = document.getElementById("app")
    return app.__vue_app__._instance.appContext.config.globalProperties.$pinia._s
        .get('org').$state.orgList.list.map(
            (v, k) => ({index: k+1, id: v.id, name: v.organization_name})
        ).filter(v => v.name.indexOf(name) >= 0).map(v => v.index)
}
```
