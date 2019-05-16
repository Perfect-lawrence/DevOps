#!/bin/bash
#author_='xiangxiaohai@b1024.cn'
project_name=$1
cd /etc/vsftpd
sed -i '/'"$project_name"'/d' /etc/vsftpd/home_locked_user.txt
sed -i '/'"$project_name"'/,+1d' /etc/vsftpd/vuser
rm -f /etc/vsftpd/vsftpd_user_conf/$project_name
rm -f /etc/vsftpd/vuser.db
if [ -x /etc/vsftpd/create_vuser_db.sh ]; then
./create_vuser_db.sh
fi

