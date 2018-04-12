#N2N启动，FCN启动，Ngrok启动，FRP启动

#wget  -O /tmp/MyNetScript.sh http://txdn.tk/SH/K3LEDE.sh
#chmod 755 "/tmp/MyNetScript.sh"
#/tmp/MyNetScript.sh &
#logger -t "【网络启动脚本】" "脚本完成"

#N2N启动
/usr/bin/edge21 -d lucktu_V21 -a 10.22.1.4 -c blackduck -k 123 -f -L 192.168.3.4 -l n2n.lucktu.com:10088 -r -b &
/usr/bin/edge21 -d udpfile_V21 -a 10.22.2.4 -c blackduck -k 123 -f -L 192.168.3.4 -l n2n.udpfile.com:10088 -r -b &
/usr/bin/edge21 -d yingftf_V21 -a 10.22.3.4 -c blackduck -k 123 -f -L 192.168.3.4 -l n2n.yingftf.cn:10088 -r -b &
iptables -t nat -A POSTROUTING -j MASQUERADE &
iptables -I INPUT -i lucktu_V21 -j ACCEPT &
iptables -I INPUT -i udpfile_V21 -j ACCEPT &
iptables -I INPUT -i yingftf_V21 -j ACCEPT &

logger -t "【N2N启动脚本】" "脚本完成"
