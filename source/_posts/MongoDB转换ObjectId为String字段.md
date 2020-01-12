---
title: MongoDB转换ObjectId为String字段
date: 2020-01-12 17:28:00
description: "新增一个id字段，将_id转换为String字段"
tags:
- mongodb
categories:
- Database
---
新增一个id字段，将_id转换为String字段：
```js
db.roomscates.find().forEach(doc => {
    db.roomscates.update({_id: doc._id}, {
        $set: {id: String(doc._id.str)} 
    })
})
```
