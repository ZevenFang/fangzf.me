---
title: Shadowsocks Kcptun
date: 2019-06-03 13:33:00
description: "Install shadowsocks and kcptun"
---

### Shadowsocks

wget --no-check-certificate -O shadowsocks-all.sh https://raw.githubusercontent.com/teddysun/shadowsocks_install/master/shadowsocks-all.sh
chmod +x shadowsocks-all.sh
./shadowsocks-all.sh 2>&1 | tee shadowsocks-all.log

[shadowsocks-all.sh](https://raw.githubusercontent.com/ZevenFang/assets/8dc9f7a61536ebf0c93dbf04a78e0af4d86c489e/fangzf.me/files/shadowsocks-all.sh)

### Kcptun

wget --no-check-certificate https://github.com/kuoruan/shell-scripts/raw/master/kcptun/kcptun.sh
sh kcptun.sh

[kcptun.sh](https://raw.githubusercontent.com/ZevenFang/assets/8dc9f7a61536ebf0c93dbf04a78e0af4d86c489e/fangzf.me/files/kcptun.sh)
