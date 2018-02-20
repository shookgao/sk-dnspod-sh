#!/bin/sh
# 路由器上使用的DDOS脚本

# 引入配置文件
source $(cd `dirname $0`; pwd)"/dnspod.conf"
# 取记录列表信息
REMOTE_MSG=`curl -s -X POST https://dnsapi.cn/Record.List -d "login_token=$TOKEN&format=json&domain=$DOMAIN&sub_domain=$SUB_DOMAIN"`
# 从记录列表信息中取出记录ID
RECORD_ID=`echo $REMOTE_MSG | sed 's/.*\[{"id":"\([0-9]*\)".*/\1/'`
# 从记录列表信息中取出远程IP
REMOTE_IP=`echo $REMOTE_MSG | sed 's/.*,"value":"\([0-9\.]*\)".*/\1/'`

# 无限循环比对本地地址和远程地址，如果不对，则更新远程记录和远程IP地址
while true;do
        # 延时
        sleep $TIME"m"
        # 取本地IP地址
        LOCAL_IP=`ifconfig $ETHERNET|awk -F '[ :]+' 'NR==2{print $4}'`
        if [ $LOCAL_IP != $REMOTE_IP ];then
                REMOTE_IP=`curl -s -X POST https://dnsapi.cn/Record.Ddns -d "login_token=$TOKEN&format=json&domain=$DOMAIN&record_id=$RECORD_ID&record_line=默认&sub_domain=$SUB_DOMAIN" | sed 's/.*,"value":"\([0-9\.]*\)".*/\1/'`
        fi
done