#!/bin/sh

#启动n2n脚本
killall edge
killall edge2
/etc/storage/bin/n2n/edge -d n2n_v1 -a 10.10.1.12 -c blackduck -k 123 -l kai.lucktu.com:10082 &
#/etc/storage/bin/n2n/edge2 -d n2n_v2 -a 10.10.10.12 -c blackduck -k 123 -l kai.lucktu.com:10086 &

/etc/storage/bin/n2n/edge -d lucktu -a 10.10.4.12 -c blackduck -k 123 -l n2n.lucktu.com:10082 &

#/etc/storage/bin/n2n/edge -d txdn_v1 -a 10.10.3.12 -c blackduck -k 123 -l n2n.txdn.tk:10082 &

/etc/storage/bin/n2n/edge -d lu8_v1 -a 10.10.2.12 -c blackduck -k 123 -l n2n.lu8.win:10082 &
#/etc/storage/bin/n2n/edge2 -d lu8_v2 -a 10.10.20.12 -c blackduck -k 123 -l n2n.lu8.win:10086 &

logger -t "【N2N启动脚本】" "脚本完成"

#  启动Ngrok脚本
#ln -s /etc/storage/bin/ngrokc /opt/bin/ngrokc
export PATH='/etc/storage/bin:/opt/usr/sbin:/opt/usr/bin:/opt/sbin:/opt/bin:/usr/local/sbin:/usr/sbin:/usr/bin:/sbin:/bin'
export LD_LIBRARY_PATH=/lib:/opt/lib
killall ngrokc
#启动ngrok功能后会运行以下脚本
#使用方法请查看论坛教程:http://www.right.com.cn/forum/thread-182340-1-1.html
#ngrokc -SER[Shost:服务器域名,Sport:服务器端口,Atoken:服务器密码] -AddTun[Type:协议,Lhost:本地ip,Lport:本地端口,Rport:外网访问端口]
#参数说明
#Shost -服务器服务器地址
#Sport -服务器端口
#Atoken -服务器认证串
#type -协议类型，tcp,http,https
#Lhost -本地地址，如果是本机直接127.0.0.1
#Lport -本地端口
#Sdname -子域名
#Hostname -自定义域名映射 备注：需要做域名解释到服务器地址
#Rport -远程端口，tcp映射的时候，制定端口使用。

ngrokc -SER[Shost:ittun.com,Sport:36415,Atoken:] -AddTun[Type:http,Lhost:192.168.123.1,Lport:80,Sdname:blackduck2] & 
ngrokc -SER[Shost:tcp.ittun.com,Sport:44433,Atoken:] -AddTun[Type:tcp,Lhost:192.168.123.1,Lport:22,Rport:51684] &

logger -t "【Ngrok启动脚本】" "脚本完成"

#  启动FRP脚本
#export PATH='/opt/usr/sbin:/opt/usr/bin:/opt/sbin:/opt/bin:/usr/local/sbin:/usr/sbin:/usr/bin:/sbin:/bin'
#export LD_LIBRARY_PATH=/lib:/opt/lib
killall frpc frps
mkdir -p /tmp/frp
#启动frp功能后会运行以下脚本
#使用方法请查看论坛教程地址: http://www.right.com.cn/forum/thread-191839-1-1.html
#frp项目地址教程: https://github.com/fatedier/frp/blob/master/README_zh.md
#请自行修改 auth_token 用于对客户端连接进行身份验证
# IP查询： http://119.29.29.29/d?dn=github.com
#客户端配置：
cat > "/tmp/frp/myfrpc.ini" <<-\EOF
[common]
server_addr = frp.lu8.win
server_port = 7000
privilege_token = frp888
[web_blackduck2]
privilege_mode = true
remote_port = 6000
type = http
local_ip = 192.168.123.1
local_port = 80
use_gzip = true
#subdomain = test
custom_domains = blackduck2.frp.lu8.win
#host_header_rewrite = 实际你内网访问的域名，可以供公网的域名不一致，如果一致可以不写
log_file = /dev/null
log_level = info
log_max_days = 3
[tcp_blackduck2]
type = tcp
privilege_mode = true
local_ip = 192.168.123.1
local_port = 22
remote_port = 51684
EOF

cat > "/tmp/frp/myfrpc2.ini" <<-\EOF
[common]
server_addr = frp3.chuantou.org
server_port = 7000
privilege_token = www.xxorg.com
[web_blackduck2]
type = http
local_ip = 192.168.123.1
local_port = 80
use_gzip = true
use_encryption = true
pool_count = 20
privilege_mode = true
custom_domains = blackduck2.frp3.chuantou.org
log_file = /dev/null
log_level = info
log_max_days = 3
[tcp_blackduck2]
type = tcp
privilege_mode = true
local_ip = 192.168.123.1
local_port = 22
remote_port = 51684
EOF


#启动：
frpc -c /tmp/frp/myfrpc.ini &
#frpc -c /tmp/frp/myfrpc1.ini &
frpc -c /tmp/frp/myfrpc2.ini &
logger -t "【FRP启动脚本】" "脚本完成"
