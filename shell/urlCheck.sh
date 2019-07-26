#!/bin/bash
web=(https://bbb.cn/monitor.htm https://vvvv.cn/monitor.htm https://eee.cn/monitor.htm)

web2=(https://dd.com/index.php https://ee.com/info.php)
rec="xxxx@yyy.com aaa@bbb.com"
web_length=${#web[@]}
for((i=0;i<$web_length;i++))
do
pj=$(/usr/bin/curl -I --connect-timeout 15 -o /dev/null -s -w %{http_code} "${web[$i]}")

if [ "${pj}" -eq 200 ]; then
    echo "${pj} url ok"
else
    echo "${web[$i]} url status code:${pj}" |mailx -s "dkfdkds" $rec
fi
done 



web2=(https://xxxx.com/index.jsp https://yyy.com/index.jsp https://zzz.com/index.jsp)
web2_length=${#web2[@]}
for((i=0;i<$web2_length;i++))
do
	sleep 1
	infox=$(/usr/bin/curl -I --connect-timeout 15 -o /dev/null -s -w %{http_code} "${web2[$i]}")
	if [ "${infox}" -ne 200 ]; then
    #echo "${infox} url ok"
#else
    echo "${web2[$i]} url status code:${infox}"
fi
done 
