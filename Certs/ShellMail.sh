#!/bin/bash
# lawrence@b1024.cn
# 腾讯企业邮箱 配置

[ "$EUID" != "0" ] && echo "Please switch root User" && exit 4
# sysctl -w net.ipv4.ip_forward=0 > /dev/null 2>&1
# function UsageMethod(){

# }
SenderUser=$1
SenderPassword=$2
function Certs(){
	[ ! -d /etc/ssl/SendMail_ssl ] && mkdir -vp /etc/ssl/SendMail_ssl
	# 获取邮件服务器证书内容（可以去掉管道服 "|"，看执行过程）
	echo -n | openssl s_client -connect smtp.exmail.qq.com:465| sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > /etc/ssl/SendMail_ssl/paojiao_cn.crt 
	#添加证书到数据库
	/usr/bin/certutil -A -n "GeoTrust SSL CA - G3" -t "Pu,Pu,Pu"  -d /etc/ssl/SendMail_ssl -i /etc/ssl/SendMail_ssl/paojiao_cn.crt
	chmod 644  /etc/ssl/SendMail_ssl/*
	# 列出指定目录下的证书
	/usr/bin/certutil -L -d /etc/ssl/SendMail_ssl/
	
# #指明受信任证书（因为上面两个-t后的C标签是会报错的，Pu可以防止报错
# /usr/bin/certutil -A -n "GeoTrust Global CA"-t "C,,"-d /etc/ssl/SendMail_ssl/ -i /etc/ssl/SendMail_ssl/paojiao_cn.crt # gmail的证书是google自己签发的，用C标签没问题
# echo "xxx" |mailx -s "aaaaa" xxx.@xxx.cn  会报错误： Error initializing NSS: Unknown error -8015  那是因为gmail的证书是google自己签发的，用C标签是没问题,我们用的不是gmail
}

function ConfigureMail(){
# 阿里云封闭25端口，所以不能通过默认的端口（25）发送邮箱，需要通过邮箱服务器的加密端口（465）来完成发送邮件的服务
if [ -f /etc/mail.rc ]; then
	if [[ $(grep "ssl-verify=ignore" /etc/mail.rc ) != "set ssl-verify=ignore" ]]; then
		#发送邮件后显示的邮件发送方
		echo "set from=${SenderUser}" >>/etc/mail.rc 
		#腾讯企业邮箱smtp邮件服务器地址
		echo 'set smtp="smtps://smtp.exmail.qq.com:465"' >>/etc/mail.rc
		#发件人邮箱
		echo "set smtp-auth-user=${SenderUser}" >>/etc/mail.rc
		#发件邮箱随机密码（设置-微信绑定-安全登录-客户端专用密码）
		echo "set smtp-auth-password=${SenderPassword}" >>/etc/mail.rc
		#证书所在目录
		echo "set nss-config-dir=/etc/ssl/SendMail_ssl" >>/etc/mail.rc
		#忽略SSL验证
		echo "set ssl-verify=ignore" >>/etc/mail.rc
		#动作为登录
		echo "set smtp-auth=login" >>/etc/mail.rc
	fi
fi
}

rc=0
case "$@" in
	certs)
		Certs
		;;
	config)
		ConfigureMail
		;;
	-h|--help|*)
		echo $"Usage: $0 { }"
		exit 2
esac
exit $rc
