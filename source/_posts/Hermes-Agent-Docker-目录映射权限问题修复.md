---
title: "Hermes Agent Docker 目录映射权限问题修复：/opt/data Permission denied"
date: 2026-05-27 18:30:00
categories: [Docker, AI]
tags: [Hermes, Docker, Linux, 权限]
description: "记录一次 Hermes Agent 使用 Docker 整个目录映射到 /opt/data 时遇到的 chown 和 mkdir 权限问题，以及如何用 HERMES_UID/HERMES_GID 修复宿主机目录权限。"
---

最近在用 Docker 跑 Hermes Agent 时遇到一个很典型的权限问题。

一开始容器日志里出现：

```bash
chown: changing ownership of '/opt/data/config.yaml': Operation not permitted
```

后来调整目录映射后，又出现：

```bash
Dropping root privileges
mkdir: cannot create directory '/opt/data': Permission denied
```

这个问题表面看是 `/opt/data` 不能写，实际根因是：Hermes Agent 的 Docker 镜像会先用 root 做初始化，然后切换到非 root 的 `hermes` 用户运行。如果宿主机映射进来的目录不属于这个 UID/GID，或者文件系统不允许容器修改属主，就会出现 `chown` 或 `mkdir` 权限错误。

## 一、为什么要映射整个目录

按照 Hermes Agent 官方 Docker 文档，容器内的 `/opt/data` 是完整数据目录，不只是一个配置文件。

它通常会保存：

- `config.yaml`
- `.env`
- `skills/`
- `sessions/`
- `memories/`
- `home/`
- `logs/`

官方文档也明确说明，Docker 运行时会把宿主机目录挂载到容器的 `/opt/data`，用于持久化配置、API Key、会话、skills 和记忆等数据。

参考文档：[Hermes Agent Docker 文档](https://hermes-agent.nousresearch.com/docs/user-guide/docker/)

所以，如果你希望保留 skills、会话和长期记忆，不建议只映射单个 `config.yaml`。更合理的做法是映射整个数据目录。

## 二、推荐的 docker-compose 配置

假设宿主机数据目录是：

```bash
/srv/hermes/data
```

可以这样写 `docker-compose.yml`：

```yaml
services:
  hermes:
    image: nousresearch/hermes-agent:latest
    container_name: hermes-agent
    restart: unless-stopped
    command: gateway run
    volumes:
      - /srv/hermes/data:/opt/data
    environment:
      - HERMES_UID=${HERMES_UID}
      - HERMES_GID=${HERMES_GID}
    networks:
      - hermes-net

networks:
  hermes-net:
    driver: bridge
```

这里关键是两个环境变量：

```yaml
HERMES_UID
HERMES_GID
```

它们用来告诉容器：Hermes 降权后应该使用哪个宿主机 UID/GID。只要容器内的运行用户和宿主机目录属主一致，整个目录映射就会稳定很多。

## 三、创建 Compose 使用的 .env 文件

在 `docker-compose.yml` 同级目录创建 `.env`：

```bash
cat > .env <<EOF
HERMES_UID=$(id -u)
HERMES_GID=$(id -g)
EOF
```

注意，这个 `.env` 是给 Docker Compose 读取变量用的，不是 Hermes 数据目录里的 `/opt/data/.env`。

如果想手动查看当前用户 UID/GID：

```bash
id
```

输出类似：

```bash
uid=1000(appuser) gid=1000(appuser) groups=1000(appuser)
```

那就说明 `HERMES_UID=1000`，`HERMES_GID=1000`。

## 四、修复宿主机数据目录权限

先停掉容器：

```bash
docker compose down
```

创建数据目录：

```bash
sudo mkdir -p /srv/hermes/data
```

把目录属主改成当前宿主机用户：

```bash
sudo chown -R "$(id -u):$(id -g)" /srv/hermes/data
```

设置目录和文件权限：

```bash
sudo find /srv/hermes/data -type d -exec chmod 775 {} \;
sudo find /srv/hermes/data -type f -exec chmod 664 {} \;
```

如果你明确知道运行用户，例如用户叫 `appuser`，也可以这样：

```bash
sudo chown -R appuser:appuser /srv/hermes/data
```

确认目录权限：

```bash
ls -ld /srv/hermes/data
ls -l /srv/hermes/data | head
```

正常情况下，目录属主应该和 `HERMES_UID/HERMES_GID` 对应的宿主机用户一致。

## 五、重新启动并验证

重新创建容器：

```bash
docker compose up -d --force-recreate
```

查看日志：

```bash
docker logs -f hermes-agent
```

如果日志里看到类似：

```bash
Changing hermes UID to 1000
Changing hermes GID to 1000
Fixing ownership of /opt/data to hermes (1000)
Dropping root privileges
```

并且没有继续出现 `Permission denied`，说明权限已经对齐。

还可以用一个临时容器直接验证 `/opt/data` 是否可写：

```bash
docker run --rm \
  -e HERMES_UID="$(id -u)" \
  -e HERMES_GID="$(id -g)" \
  -v /srv/hermes/data:/opt/data \
  --entrypoint sh \
  nousresearch/hermes-agent:latest \
  -lc 'id; ls -ld /opt/data; touch /opt/data/.write-test && echo OK'
```

如果最后输出 `OK`，说明映射目录具备写权限。

## 六、常见坑

### 1. 目录属主还是别的用户

如果 `ls -l` 看到目录属主是 `www:www`、`root:root` 或其他用户，而容器日志里显示 Hermes 使用的是 `1000:1000`，就会写不进去。

修复方式：

```bash
sudo chown -R 1000:1000 /srv/hermes/data
```

如果你的 UID/GID 不是 `1000:1000`，把命令里的数字替换成 `id` 查到的实际值。

### 2. 只修改了文件，没有修改目录

目录是否可写，取决于目录本身权限。只给 `config.yaml` 加写权限不够。

需要确认：

```bash
ls -ld /srv/hermes/data
```

目录至少要让 Hermes 运行用户具备进入和写入权限。

### 3. 宿主机文件系统不支持 chown

如果数据目录位于某些 NAS、SMB、NTFS、rootless Docker 或特殊挂载文件系统上，即使容器里是 root，也可能不能修改属主。

这种情况下，不要依赖容器内 `chown` 修复权限，而应该在宿主机上提前把目录权限设置正确，并通过 `HERMES_UID/HERMES_GID` 让容器内运行用户匹配宿主机目录所有者。

### 4. Compose 的 .env 和 Hermes 的 .env 不是一个文件

Docker Compose 的 `.env` 位于 `docker-compose.yml` 同级目录，用来给 compose 文件做变量替换。

Hermes 的 `.env` 位于数据目录里，也就是容器里的 `/opt/data/.env`，通常保存模型 API Key、Bot Token 等运行配置。

这两个文件用途不同，不要混在一起。

## 七、最终可用命令汇总

如果只想快速修复，可以直接按这个顺序执行：

```bash
cd /path/to/your/compose-dir

cat > .env <<EOF
HERMES_UID=$(id -u)
HERMES_GID=$(id -g)
EOF

docker compose down

sudo mkdir -p /srv/hermes/data
sudo chown -R "$(id -u):$(id -g)" /srv/hermes/data
sudo find /srv/hermes/data -type d -exec chmod 775 {} \;
sudo find /srv/hermes/data -type f -exec chmod 664 {} \;

docker compose up -d --force-recreate
docker logs -f hermes-agent
```

对应的 compose 核心配置是：

```yaml
volumes:
  - /srv/hermes/data:/opt/data
environment:
  - HERMES_UID=${HERMES_UID}
  - HERMES_GID=${HERMES_GID}
```

## 总结

Hermes Agent Docker 部署时，`/opt/data` 不是普通配置文件目录，而是保存配置、skills、会话、记忆和运行数据的核心目录。

如果要完整保留这些数据，应该映射整个目录，并确保宿主机目录属主和容器内 Hermes 降权后的 UID/GID 一致。

遇到 `Operation not permitted` 或 `Permission denied` 时，不要只盯着 `config.yaml`，重点检查三件事：

- 宿主机目录属主是谁
- 容器内 Hermes 实际使用哪个 UID/GID
- `docker-compose.yml` 是否设置了 `HERMES_UID/HERMES_GID`

把这三点对齐后，整个目录映射就可以正常使用。
