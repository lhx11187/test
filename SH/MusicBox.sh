#!/bin/sh

#启动n2n脚本
killall edgev1
killall edge2


#/opt/bin/edge -d n2n_v1 -a 10.10.1.14 -c blackduck -k 123 -l kai.lucktu.com:10082 &
#/opt/bin/edge -d lu8_v1 -a 10.10.2.14 -c blackduck -k 123 -l n2n.lu8.win:10082 &
#/opt/bin/edge -d txdn_v1 -a 10.10.3.14 -c blackduck -k 123 -l n2n.txdn.tk:10082 &
#/opt/bin/edge -d lucktu -a 10.10.4.14 -c blackduck -k 123 -l n2n.lucktu.com:10082 &
#/opt/bin/edge -d udpfile_v1 -a 10.10.5.14 -c blackduck -k 123 -l n2n.udpfile.com:10082 &
/opt/bin/edgev1 -d llfj_v1 -a 10.10.6.14 -c blackduck -k 123 -l n2n.llfj.party:10082 & #苏州电信
/opt/bin/edgev1 -d laiyx_v1 -a 10.10.7.14 -c blackduck -k 123 -l n2n.laiyx.win:10082 & #美国
/opt/bin/edgev1 -d rb_v1 -a 10.10.8.14 -c blackduck -k 123 -l 106.186.30.16:6489 & #日本
#/opt/bin/n2n/edge -d laiyx_mg_v1 -a 10.10.9.14 -c blackduck -k 123 -l n2n.laiyx.win:10082 &

#捷克	remoteqth.com:82
#日本 106.186.30.16:6489


logger -t "【N2N启动脚本】" "脚本完成"

#  启动Ngrok脚本
export PATH='/opt/usr/sbin:/opt/usr/bin:/opt/sbin:/opt/bin:/usr/local/sbin:/usr/sbin:/usr/bin:/sbin:/bin'
export LD_LIBRARY_PATH=/lib:/opt/lib
killall ngrok
screen -S ngrokssh ngrok -config /opt/bin/tcp.ittun.yml start ssh
screen -S ngrokaria ngrok -config /opt/bin/tcp.ittun.yml start aria
screen -S ngroktp ngrok -config /opt/bin/tcp.ittun.yml start tinyproxy
#ngrok -config /opt/bin/tcp.ittun.yml start ssh & #51687-->22
#ngrok -config /opt/bin/tcp.ittun.yml start aria & #51688-->6800
#ngrok -config /opt/bin/tcp.ittun.yml start tinyproxy & #51689-->9999

screen ngrok -config /opt/bin/ittun.yml start web #blackduck4
screen ngrok -config /opt/bin/ittun.yml start tr  #blackduck4_9091
screen ngrok -config /opt/bin/ittun.yml start amule  #blackduck4_4711

#ngrok -config /opt/bin/ittun.yml start web & #blackduck4
#ngrok -config /opt/bin/ittun.yml start tr & #blackduck4_9091
#ngrok -config /opt/bin/ittun.yml start amule & #blackduck4_4711


logger -t "【Ngrok启动脚本】" "脚本完成"

#  启动FRP脚本
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
#server_addr = 115.159.6.79
#server_port = 7000
#privilege_token = txdn
server_addr = frp.lu8.win
server_port = 7000
privilege_token = frp888
[web_blackduck4]
privilege_mode = true
#remote_port = 6000
type = http
local_ip = 192.168.3.196
local_port = 80
use_gzip = true
use_encryption = true
pool_count = 20
#subdomain = test
custom_domains = blackduck4.frp.lu8.win
#host_header_rewrite = 实际你内网访问的域名，可以供公网的域名不一致，如果一致可以不写
log_file = /dev/null
log_level = info
log_max_days = 3
[tcp_blackduck4]
type = tcp
privilege_mode = true
local_ip = 192.168.3.196
local_port = 22
remote_port = 51687
EOF

cat > "/tmp/frp/myfrpc1.ini" <<-\EOF
[common]
server_addr = www.ifrp.ga
server_port = 7000
privilege_token = yzxx
[web_blackduck4]
type = http
local_ip = 192.168.3.196
local_port = 80
use_gzip = true
use_encryption = true
pool_count = 20
privilege_mode = true
custom_domains = blackduck4.ifrp.ga
log_file = /dev/null
log_level = info
log_max_days = 3
[tcp_blackduck4]
type = tcp
privilege_mode = true
local_ip = 192.168.3.196
local_port = 22
remote_port = 51687
EOF


cat > "/tmp/frp/myfrpc2.ini" <<-\EOF
[common]
server_addr = frp3.chuantou.org
server_port = 7000
privilege_token = www.xxorg.com
[web_blackduck4]
type = http
local_ip = 192.168.3.196
local_port = 80
use_gzip = true
use_encryption = true
pool_count = 20
privilege_mode = true
custom_domains = blackduck4.frp3.chuantou.org
log_file = /dev/null
log_level = info
log_max_days = 3
[tcp_blackduck4]
type = tcp
privilege_mode = true
local_ip = 192.168.3.196
local_port = 22
remote_port = 51687
EOF

#启动：
frpc -c /tmp/frp/myfrpc.ini &
frpc -c /tmp/frp/myfrpc1.ini &
frpc -c /tmp/frp/myfrpc2.ini &
logger -t "【FRP启动脚本】" "脚本完成"
