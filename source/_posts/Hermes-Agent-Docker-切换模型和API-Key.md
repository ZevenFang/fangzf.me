---
title: "Hermes Agent Docker 切换模型和 API Key：gateway run 模式下的操作步骤"
date: 2026-07-03 18:30:00
description: "记录 Hermes Agent 使用 Docker 运行 gateway run 时，如何进入容器、激活虚拟环境、通过 hermes model 切换底层模型，以及修改 /opt/data/.env 中的模型 API Key。"
tags:
- Hermes
- Docker
- AI Agent
- LLM
categories:
- AI
---

Hermes Agent 用 Docker 跑起来之后，很多配置都不在宿主机当前目录，而是在容器内部和挂载的数据目录里。

如果容器启动命令是：

```yaml
command: gateway run
```

那么容器主进程跑的是 Hermes gateway。这个时候想切换底层模型，或者更换模型服务商的 API Key，不是去改 Docker 镜像，也不是重新拉镜像，而是进入容器后使用 Hermes 自带的模型配置命令，并确认 `/opt/data/.env` 中的 key 是否正确。

下面记录一套相对稳的操作步骤。

## 一、进入 Hermes 容器

先进入正在运行的容器：

```bash
docker exec -it hermes-agent /bin/bash
```

如果镜像里没有 `bash`，可以改成：

```bash
docker exec -it hermes-agent /bin/sh
```

进入后切到 Hermes 目录：

```bash
cd /opt/hermes
```

激活虚拟环境：

```bash
source .venv/bin/activate
```

确认当前命令来自虚拟环境：

```bash
which hermes
which python
```

正常应该类似：

```text
/opt/hermes/.venv/bin/hermes
/opt/hermes/.venv/bin/python
```

虽然直接执行 `/opt/hermes/.venv/bin/hermes` 也能使用虚拟环境，但进入 bash 后手动 `source` 一下更直观，后续排查路径和依赖问题也更方便。

## 二、使用 hermes model 切换模型

在容器里执行：

```bash
hermes model
```

这个命令会进入模型配置向导，通常会让你选择：

- 模型服务商，例如 OpenAI、Anthropic、OpenRouter 等
- 具体模型
- 是否保存为默认配置
- 如果缺少 API Key，会提示补充

切换完成后，配置会写入 Hermes 的数据目录。Docker 模式下，数据目录一般是容器内的：

```bash
/opt/data
```

它通常由宿主机目录挂载进来，例如：

```yaml
volumes:
  - /srv/hermes/data:/opt/data
```

这样容器重启后，模型配置、会话、skills、记忆和 `.env` 等数据都还在。

## 三、区分 gateway key 和模型 API Key

这里容易混淆两个 key。

`API_SERVER_KEY` 是访问 Hermes gateway 的鉴权 key，用来保护 gateway 接口。

模型 API Key 是 Hermes 调用底层模型服务时用的 key，例如：

```bash
OPENAI_API_KEY=...
ANTHROPIC_API_KEY=...
OPENROUTER_API_KEY=...
GOOGLE_API_KEY=...
DEEPSEEK_API_KEY=...
```

如果只是更换模型服务商的 key，改的是模型 API Key，不是 `API_SERVER_KEY`。

## 四、修改 /opt/data/.env 中的模型 API Key

先查看数据目录：

```bash
ls -la /opt/data
```

如果已经有 `.env` 文件，可以先备份：

```bash
cp /opt/data/.env /opt/data/.env.bak.$(date +%Y%m%d-%H%M%S)
```

更换 OpenRouter key：

```bash
read -s OPENROUTER_API_KEY
sed -i '/^OPENROUTER_API_KEY=/d' /opt/data/.env
printf '\nOPENROUTER_API_KEY=%s\n' "$OPENROUTER_API_KEY" >> /opt/data/.env
```

更换 Anthropic key：

```bash
read -s ANTHROPIC_API_KEY
sed -i '/^ANTHROPIC_API_KEY=/d' /opt/data/.env
printf '\nANTHROPIC_API_KEY=%s\n' "$ANTHROPIC_API_KEY" >> /opt/data/.env
```

更换 OpenAI key：

```bash
read -s OPENAI_API_KEY
sed -i '/^OPENAI_API_KEY=/d' /opt/data/.env
printf '\nOPENAI_API_KEY=%s\n' "$OPENAI_API_KEY" >> /opt/data/.env
```

这里用 `read -s` 是为了避免 key 直接显示在终端上。执行时粘贴 key 后按回车即可。

如果 `/opt/data/.env` 不存在，可以先创建：

```bash
touch /opt/data/.env
chmod 600 /opt/data/.env
```

再追加对应的模型 API Key。

## 五、注意 Docker Compose 的 environment 覆盖

如果 `docker-compose.yml` 里也写了同名环境变量，例如：

```yaml
environment:
  - OPENROUTER_API_KEY=old-key
```

那么容器启动时的环境变量可能会覆盖 `/opt/data/.env` 中的值。

更稳妥的做法是：

- `docker-compose.yml` 里只放运行参数，例如 `HERMES_UID`、`HERMES_GID`
- 模型服务商 API Key 放到 `/opt/data/.env`
- 不要把真实 key 写进公开仓库

如果确实要通过 Compose 管理 key，也要改完后重新创建容器：

```bash
docker compose up -d
```

## 六、重启 gateway

模型和 key 改完后，退出容器：

```bash
exit
```

然后在宿主机重启 Hermes 容器：

```bash
docker restart hermes-agent
```

如果使用的是 Docker Compose：

```bash
docker compose restart hermes
```

查看日志：

```bash
docker logs -f hermes-agent
```

如果启动正常，说明 gateway 已经使用新的配置继续运行。

## 七、常见问题

### 1. 为什么已经激活 venv，还是启动很慢

如果直接运行 `hermes` 时卡在 banner 或工具检查阶段，通常不是虚拟环境没有激活，而是 Hermes 在启动时检查某些工具集依赖。

可以先用：

```bash
hermes chat --quiet
```

跳过 banner，确认主流程是否正常。

### 2. gateway run 模式下能不能再进容器执行 hermes model

可以。

`gateway run` 是容器的主进程。通过 `docker exec` 进入容器后，再执行 `hermes model`，相当于在同一个容器环境里额外运行一次配置命令。配置写入 `/opt/data` 后，重启 gateway 即可让新配置生效。

### 3. 改了 .env 但没生效

优先检查这几件事：

- 是否改的是容器内的 `/opt/data/.env`
- 宿主机挂载目录是否正确
- `docker-compose.yml` 里是否有同名环境变量覆盖
- 改完后是否重启了容器
- `hermes model` 里选择的 provider 是否和 `.env` 中的 key 对应

## 总结

Hermes Agent Docker 模式下切换模型，大致就是四步：

```bash
docker exec -it hermes-agent /bin/bash
cd /opt/hermes
source .venv/bin/activate
hermes model
```

如果要切换模型 API Key，就修改：

```bash
/opt/data/.env
```

改完后重启：

```bash
docker restart hermes-agent
```

核心思路是：模型配置交给 `hermes model`，模型服务商密钥放在 `/opt/data/.env`，Docker 只负责把这个数据目录持久化下来。
