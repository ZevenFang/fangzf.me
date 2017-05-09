---
title: MySQL用户授权
date: 2016-04-24 21:59:53
description: "用户管理:use mysql;查看:select host,user,password from user;创建:create user zx_root IDENTIFIED by 'xxxxx';修改:rename user feng to newuser;"
tags:
- mysql
categories:
- Database
---
用户管理
```sql
use mysql;
```
查看
```sql
select host,user,password from user ;
```
创建
```sql
create user zx_root IDENTIFIED by 'xxxxx';
--identified by 会将纯文本密码加密作为散列值存储
```
修改
```sql
rename user feng to newuser;
--mysql 5之后可以使用，之前需要使用update 更新user表
```
删除
```sql
drop user newuser;
--mysql5之前删除用户时必须先使用revoke 删除用户权限，然后删除用户，mysql5之后drop 命令可以删除用户的同时删除用户的相关权限
```
更改密码
```sql
set password for zx_root =password('xxxxxx');
update  mysql.user  set  password=password('xxxx')  where user='otheruser'
```
查看用户权限
```sql
show grants for zx_root;
```
赋予权限
```sql
grant select on dmc_db.*  to zx_root;
```
回收权限
```sql
revoke  select on dmc_db.*  from  zx_root;
--如果权限不存在会报错
```
上面的命令也可使用多个权限同时赋予和回收，权限之间使用逗号分隔
```sql
grant select，update，delete  ，insert  on dmc_db.*  to  zx_root;
```
如果想立即看到结果使用
```sql
flush privileges;
```
命令更新
设置权限时必须给出一下信息
1. 要授予的权限
2. 被授予访问权限的数据库或表
3. 用户名

grant和revoke可以在几个层次上控制访问权限
- 整个服务器，使用 grant ALL  和revoke  ALL
- 整个数据库，使用on  database.*
- 特点表，使用on  database.table
- 特定的列
- 特定的存储过程

user表中host列的值的意义
- %              匹配所有主机
- localhost    localhost不会被解析成IP地址，直接通过UNIXsocket连接
- 127.0.0.1      会通过TCP/IP协议连接，并且只能在本机访问；
- ::1                 ::1就是兼容支持ipv6的，表示同ipv4的127.0.0.1


grant 普通数据用户，查询、插入、更新、删除 数据库中所有表数据的权利。

```sql
grant select on testdb.* to common_user@'%'
grant insert on testdb.* to common_user@'%'
grant update on testdb.* to common_user@'%'
grant delete on testdb.* to common_user@'%'
```

或者，用一条 MySQL 命令来替代：
```sql
grant select, insert, update, delete on testdb.* to common_user@'%'
```
grant 数据库开发人员，创建表、索引、视图、存储过程、函数。。。等权限。
grant 创建、修改、删除 MySQL 数据表结构权限。
```sql
grant create on testdb.* to developer@'192.168.0.%';
grant alter on testdb.* to developer@'192.168.0.%';
grant drop on testdb.* to developer@'192.168.0.%';
```

grant 操作 MySQL 外键权限。
```sql
grant references on testdb.* to developer@'192.168.0.%';
```

grant 操作 MySQL 临时表权限。
```sql
grant create temporary tables on testdb.* to developer@'192.168.0.%';
```

grant 操作 MySQL 索引权限。
```sql
grant index on testdb.* to developer@'192.168.0.%';
```

grant 操作 MySQL 视图、查看视图源代码 权限。
```sql
grant create view on testdb.* to developer@'192.168.0.%';
grant show view on testdb.* to developer@'192.168.0.%';
```

grant 操作 MySQL 存储过程、函数 权限。
```sql
grant create routine on testdb.* to developer@'192.168.0.%'; -- now, can show procedure status
grant alter routine on testdb.* to developer@'192.168.0.%'; -- now, you can drop a procedure
grant execute on testdb.* to developer@'192.168.0.%';
```

grant 普通 DBA 管理某个 MySQL 数据库的权限。
```sql
grant all privileges on testdb to dba@'localhost'
--其中，关键字 "privileges" 可以省略。
```

grant 高级 DBA 管理 MySQL 中所有数据库的权限。
```sql
grant all on *.* to dba@'localhost'
```

MySQL grant 权限，分别可以作用在多个层次上。

1. grant 作用在整个 MySQL 服务器上：
```sql
grant select on *.* to dba@localhost; -- dba 可以查询 MySQL 中所有数据库中的表。
grant all on *.* to dba@localhost; -- dba 可以管理 MySQL 中的所有数据库
```

2. grant 作用在单个数据库上：
```sql
grant select on testdb.* to dba@localhost; -- dba 可以查询 testdb 中的表。
```

3. grant 作用在单个数据表上：
```sql
grant select, insert, update, delete on testdb.orders to dba@localhost;
```

4. grant 作用在表中的列上：
```sql
grant select(id, se, rank) on testdb.apache_log to dba@localhost;
```

5. grant 作用在存储过程、函数上：
```sql
grant execute on procedure testdb.pr_add to 'dba'@'localhost'
grant execute on function testdb.fn_add to 'dba'@'localhost'
```

6. 注意：修改完权限以后 一定要刷新服务，或者重启服务，刷新服务用：
```sql
FLUSH PRIVILEGES;
```
