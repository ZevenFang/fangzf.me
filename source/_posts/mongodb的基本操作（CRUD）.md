---
title: mongodb的基本操作（CRUD）
date: 2016-04-26 00:34:11
description: "show dbs 查看当前系统的数据库，use test 切换到test数据库（如不存在就创建），db.dropDatabase() 删除当前所在的数据库，db.user.insert({name:'Mickle'}) 创建user集合并插入一条数据，show collections 查看当前数据库中的所有集合"
tags:
- mongodb
categories:
- Database
---
1. 查看当前系统的数据库
```
show dbs
```
2. 切换到test数据库（如不存在就创建）
```
use test
```
3. 删除当前所在的数据库
```js
db.dropDatabase()
```
4. 创建user集合并插入一条数据
```js
db.user.insert({name:'Mickle'})
```
5. 查看当前数据库中的所有集合
```
show collections
```
6. 查看集合中的数据，'\_id'索引由系统自动生成，也可以自己指定
```js
db.user.find()
```
7. 在集合中查找Mickle的数据
```js
db.user.find({name:'Mickle'})
```
8. 在mongodb可以使用js语法插入多条数据：
```js
for(i=0;i<100;i++) db.user.insert({name:'user'+i})
```
9. 计算集合中的数据条目
```js
db.user.find().count()
```
10. 选择第4条和第5条记录
```js
db.user.find().skip(3).limit(2)
```
11. 更新数据
```js
db.user.update({name:'Mickle'},{name:'Anmy'})
```
12.	只修改一条记录中的其中一项数据，如`{x:100,y:100,z:100}`，使用`$set`部分更新符只将z为100中的y值修改为99
```js
db.test.update({z:100}，{$set:{y:99}})
db.user.update({name:'aaa'},{name:'Mickle'},true) //第三个参数为true时表示，如果数据aaa不存在则插入一条Mickle数据
```
13. 为了防止误操作，mongodb的update操作只会更新第一条数据，必须将第四个参数设置为`true`，才会执行批量更新操作，并且只能使用部分更新$set进行操作
```js
db.test.update({x:1},{$set{y:99}}),false,true)
```
14.	删除name为user0的数据
```js
db.user.remove({name:'user0'})
```
15.	删除选择的集合
```js
db.user.drop()
```
