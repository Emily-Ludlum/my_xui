#!/bin/bash

# 默认设置
DEFAULT_DOMAIN="hax.vps777.tk"
DEFAULT_EMAIL="hax@vps777.tk"

# 设置默认域名和邮箱地址
DOMAIN="$DEFAULT_DOMAIN"
EMAIL="$DEFAULT_EMAIL"

# 设置防火墙规则
echo "设置防火墙规则..."
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT
iptables -F
iptables-save

# 更新系统
echo "更新系统..."
apt update -y

# 安装依赖
echo "安装依赖..."
apt install -y wget curl socat cron

# 安装 Warp
echo "安装 Warp..."
wget -N https://gitlab.com/fscarmen/warp/-/raw/main/menu.sh && bash menu.sh <<EOF
2
1
1
EOF

# 安装签发证书工具
echo "安装签发证书工具..."
curl https://get.acme.sh | sh

# 申请 SSL 证书，并下载到服务器目录
echo "申请 SSL 证书，并下载到服务器目录..."
~/.acme.sh/acme.sh --register-account -m $EMAIL
~/.acme.sh/acme.sh --issue -d $DOMAIN --standalone --listen-v6
~/.acme.sh/acme.sh --installcert -d $DOMAIN --key-file /root/private.key --fullchain-file /root/cert.crt

# 安装 X-UI
echo "正在安装 X-UI..."
wget -N --no-check-certificate https://raw.githubusercontent.com/vaxilu/x-ui/master/install.sh && bash install.sh <<EOF
y
VIP
My@123123
8880
EOF

# 提示用户设置 X-UI 的用户名、密码和端口
echo "已完成设置防火墙规则..."
echo "已完成部署 wget curl socat cron 依赖..."
echo "已完成 warp 安装及设置..."
echo "已完成申请 SSL 证书，并下载到服务器目录..."
echo "已完成设置 X-UI 的用户名、密码和端口..."

echo "安装成功!"
