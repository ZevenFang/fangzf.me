---
title: MySQL触发器
date: 2016-04-24 22:26:09
description: "触发器:能监视: 增,删,改；触发操作: 增,删,改。四要素:监视地点，监视事件，触发时间，触发事件。创建触发器的语法：删除触发器的语法："
tags:
- mysql
categories:
- Database
---
触发器:
1. 能监视: 增,删,改
2. 触发操作: 增,删,改

四要素:
- 监视地点
- 监视事件
- 触发时间
- 触发事件

创建触发器的语法
```sql
create trigger triggerName
  after/before insert/update/delete on <表名>
  for each row #这句话是固定的
begin
  <sql语句>;  #一句或多句,insert/update/delete范围内
end;
```
删除触发器的语法:
```sql
Drop trigger <触发器名>
```
查看触发器:
```sql
Show triggers
```
如何在触发器引用行的值:
- 对于insert而言, 新增的行 用new来表示
- 行中的每一列的值 ,用new.列名来表示
- 对于 delete来说, 原本有一行,后来被删除
- 想引用被删除的这一行,用old来表示,  old.列名,就可以引用被删行中的值
- 对于update来说,被修改的行
- 修改前的数据 ,用old来表示, old.列名引用被修改之前行中的值
- 修改后的数据,用new 来表示, new.列名引用被修改之后行中的值

触发器里after 和before的区别:
- After 是先完成数据的增,删,改再触发,
触发的语句晚于监视的增,删,改,无法影响前面的增删改动作.
- Before是先完成触发,再增删改,
触发的语句先于监视的增,删,改发生,我们有机会判断,修改即将发生的操作

典型案例:
- 对于所下订单,进行判断,如果订单的数量 > 5，就认为是恶意订单，
强制把所订的商品数量改成5。
