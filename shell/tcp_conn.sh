#!/bin/bash
function Tcp_conn() {
# 正常数据传输状态
# 连接已建立并正在传输数据
con=$(/usr/sbin/ss -ant | awk '{++s[$1]} END {for(k in s) print k,s[k]}' | grep 'ESTAB' | awk '{print $2}')
if [ "${con}" -ge 500 ]; then
        echo "IP Established num gt 500 current values:${con}"|mail -s "IP Established num gt 500" 
fi

#程序响应请求处理完成
#应用说它已经完成
fin=$(/usr/sbin/ss -ant | awk '{++s[$1]} END {for(k in s) print k,s[k]}' | grep 'FIN-WAIT-1' | awk '{print $2}')
if [ "${fin}" -ge 20 ]; then
        echo "IP FIN-WAIT-1 num gt 20 current values:${fin}"|mail -s "IP FIN-WAIT-1 num gt 20" xxx
fi

# 客户端接受到数据,准备释放连接
#另一边已同意释放
fin2=$(/usr/sbin/ss -ant | awk '{++s[$1]} END {for(k in s) print k,s[k]}' | grep 'FIN-WAIT-2' | awk '{print $2}')
if [ "${fin2}" -ge 30 ]; then
        echo "IP FIN-WAIT-2 num gt 30 current values:${fin2}"|mail -s "IP FIN-WAIT-2 num gt 30" xxx
fi

#另一边已初始化一个释放
#等待所有分组死掉
time_wait=$(/usr/sbin/ss -ant | awk '{++s[$1]} END {for(k in s) print k,s[k]}' | grep 'TIME-WAIT' | awk '{print $2}')
if [ "${time_wait}" -ge 200 ]; then
        echo "IP TIME-WAIT num gt 200 current values:${time_wait}"|mail -s "IP TIME-WAIT num gt 200" xxx
fi

# 正在等待处理的请求数
#等待所有分组死掉
ack=$(/usr/sbin/ss -ant | awk '{++s[$1]} END {for(k in s) print k,s[k]}' | grep 'LAST-ACK' | awk '{print $2}')
if [[ "${ack}" -ge 20 ]]; then
        echo "IP LAST-ACK num gt 20 current values:${ack}"|mail -s "IP LAST-ACK num gt 20" xxx
fi

close=$(/usr/sbin/ss -ant | awk '{++s[$1]} END {for(k in s) print k,s[k]}' | grep 'CLOSE-WAIT'|awk '{print $2}')
if [ "${close}" -ge 15 ]; then
        echo "IP CLOSE-WAIT num gt 15 current values:${close}"|mail -s "IP CLOSE-WAIT num gt 200" xxx
fi
}

