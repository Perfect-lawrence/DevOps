#!/bin/bash
#author_= 'xiangxiaohai@project.cn'
project_name=$1
project_pass=$2
project_dir=$3
cd /etc/vsftpd
echo "$project_name" >> /etc/vsftpd/home_locked_user.txt
echo "$project_name" >> /etc/vsftpd/vuser
echo "$project_pass" >> /etc/vsftpd/vuser
touch /etc/vsftpd/vsftpd_user_conf/$project_name
echo "cmds_allowed=ABOR,ACCT,APPE,CWD,CDUP,HELP,LIST,MODE,MDTM,MKD,NOOP,NLST,PASS,PASV,PORT,PWD,QUIT,REIN,RETR,RNFR,RNTO,SITE,SIZE,STOR,STAT,STOU,STRU,SYST,TYPE,USER" >> /etc/vsftpd/vsftpd_user_conf/$project_name

echo "local_root=$project_dir" >> /etc/vsftpd/vsftpd_user_conf/$project_name
rm -f /etc/vsftpd/vuser.db
if [ -x /etc/vsftpd/create_vuser_db.sh ]; then
./create_vuser_db.sh
fi

/bin/chmod 600 vuser*
/bin/chmod 600 /etc/vsftpd/vsftpd_user_conf/$project_name
