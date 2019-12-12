#!/bin/bash
#for i in admin test
for i in `cat a.txt`
do 
	expire_year=$(curl -k --connect-timeout 15 -v https://$i.infoxgame.com 2>&1|awk 'BEGIN { cert=0 }/^* Server certificate:/{ cert=1 }/^*/{ if (cert) print }'|grep "expire date:"|awk '{print $7}')
	expire_year2=$(curl -k --connect-timeout 15 -v https://$i.infoxgame.com 2>&1|awk 'BEGIN { cert=0 }/^* Server certificate:/{ cert=1 }/^*/{ if (cert) print }'|grep "expire date:")
	#sleep 2
#	echo -e "\033[32m域名 $i.infoxgame.com 有效期: $expire_year2\033[0m"
	if [[ "${expire_year}" == "2019" ]]; then
		#curl -k -v https://$i.infoxgame.com 2>&1|awk 'BEGIN { cert=0 }/^* Server certificate:/{ cert=1 }/^*/{ if (cert) print }'|grep "expire date:"
		echo -e "\033[31m域名 $i.infoxgame.com 证书过期: $expire_year2\033[0m"
		sleep 2
		#continue
		#break
	elif [[ "${expire_year}" == "2021" ]]; then
		echo -e "\033[32m域名 $i.infoxgame.com 有效期: $expire_year2\033[0m"
		sleep 2
		#continue
		#break
	fi
done
