#!/bin/bash

# 默认设置
DEFAULT_DOMAIN="xui.vvps.link"
DEFAULT_EMAIL="xui@vvps.link"

# 询问用户输入域名和邮箱地址
read -p "请输入要申请 SSL 证书的域名（默认值：$DEFAULT_DOMAIN）: " DOMAIN
read -p "请输入 SSL 证书的邮箱地址（默认值：$DEFAULT_EMAIL）: " EMAIL

# 如果用户未输入任何内容，则使用默认设置
DOMAIN=${DOMAIN:-$DEFAULT_DOMAIN}
EMAIL=${EMAIL:-$DEFAULT_EMAIL}

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

# 安装 expect 工具
apt install -y expect

# 安装 X-UI 的命令之前添加以下代码
echo "正在安装 X-UI..."
wget -N --no-check-certificate https://raw.githubusercontent.com/vaxilu/x-ui/master/install.sh && bash install.sh

# 使用 expect 来自动填入账户名、密码和端口
echo "正在设置 X-UI 的用户名、密码和端口..."
expect << EOF
spawn bash /usr/local/XrayR/install.sh
expect "设置您的账户名:"
send "VIP\n"
expect "请设置您的账户密码:"
send "My@123123\n"
expect "请设置面板访问端口:"
send "8880\n"
expect eof
EOF


# 提示用户设置 X-UI 的用户名、密码和端口
echo "已完成设置防火墙规则..."
echo "已完成部署 wget curl socat cron 依赖..."
echo "已完成 warp 安装及设置..."
echo "已完成申请 SSL 证书，并下载到服务器目录..."
echo "已完成设置 X-UI 的用户名、密码和端口..."

# 设置用户名、密码和端口变量
USERNAME="VIP"
PASSWORD="My@123123"
PORT="8880"

# 提示用户设置完成，并输出设置信息
echo "已完成设置 X-UI 的用户名、密码和端口..."
echo "用户名: $USERNAME"
echo "密码: $PASSWORD"
echo "端口: $PORT"

echo "安装成功!"
