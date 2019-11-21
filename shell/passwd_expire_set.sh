#!/bin/bash
# author_='xiangxiaohai@paojiao.cn'
#IP=$(ifconfig eth1|grep "inet addr" | awk -F[:" "]+ '{print $4}')
function set_login_file(){
if [ -f /etc/login.defs ]; then
	cp -v /etc/login.defs /etc/login.defs_`date +%Y%m%d`_bak
	sed -i -e 's/^\(PASS_MAX_DAYS\).*/\1   90/' /etc/login.defs
	sed -i -e 's/^\(PASS_MIN_LEN\).*/\1   12/' /etc/login.defs
	sed -i -e 's/^\(PASS_WARN_AGE\).*/\1  30/' /etc/login.defs
fi
}
function change_account_expire(){
for i in `grep "/bin/bash" /etc/passwd|awk -F":" '$3>=500{print $1}'`  # centos6
#for i in `awk -F":" '$3>=1000{print $1}' /etc/passwd`  # centos7
do
	echo "###############   $i    ####################"
	/usr/bin/chage -M 90 -W 30 $i
	/usr/bin/chage -l $i
done
}
function root_account_expire(){
/usr/bin/chage -l root
/usr/bin/chage -M 90 -W 30 root
}

function main(){
set_login_file
change_account_expire
root_account_expire
}
main
