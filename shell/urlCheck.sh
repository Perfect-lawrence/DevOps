#!/bin/bash
web=(https://bbb.cn/monitor.htm https://vvvv.cn/monitor.htm https://eee.cn/monitor.htm)

rec="xxxx@yyy.com aaa@bbb.com"
web_length=${#web[@]}
for((i=0;i<$web_length;i++))
do
    sleep 2
    uc=$(/usr/bin/curl -I --connect-timeout 15 -o /dev/null -s -w %{http_code} "${web[$i]}")
    
    if [ "${uc}" -eq 000 ]; then
	continue
    elif [ "${uc}" -eq 200 -o "${uc}" -eq 301 -o "${uc}" -eq 302 ]; then
	continue
    elif [ "${uc}" -eq 404 -o "${uc}" -eq 502 ]; then
        echo "${web[$i]}  monitor from VPC_56 url status code:${uc}"|mailx -s "URL monitor rec websiteFrom VPC_56" ${rec}
    else
        echo "${web[$i]}  monitor from VPC_56 url status code:${uc}"|mailx -s "URL monitor rec websiteFrom VPC_56" ${rec}
    fi

done 



web2=(https://xxxx.com/index.jsp https://yyy.com/index.jsp https://zzz.com/index.jsp)
web2_length=${#web2[@]}
for((i=0;i<$web2_length;i++))
do
    sleep 2
    w=$(/usr/bin/curl -I --connect-timeout 15 -o /dev/null -s -w %{http_code} "${web2[$i]}")
    if [ "${w}" -eq 000 ]; then
	continue
    elif [ "${w}" -eq 200 -o "${w}" -eq 301 -o "${w}" -eq 302 ]; then
	continue
    elif [ "${w}" -eq 404 -o "${w}" -eq 502 ]; then
    	echo "${web2[$i]} url status code:${w}"|mailx -s "InfoxGame URL Monitor WebSite From VPC_56" ${rec}
    else
    	echo "${web2[$i]} url status code:${w}"|mailx -s "InfoxGame URL Monitor WebSite From VPC_56" ${rec}
    fi
done 
