# Centos 安装 Gogs
* 环境
* centos：7.5 （64位）
* MariaDB ： 10.4
* git ： 1.8

## 配置Mariadb yum源

```bash
cat > /etc/yum.repos.d/Mariadb.repo<<EOF
# MariaDB 10.4 CentOS repository list - created 2019-08-13 06:55 UTC
# http://downloads.mariadb.org/mariadb/repositories/
[mariadb]
name = MariaDB
baseurl = http://yum.mariadb.org/10.4/centos7-amd64
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1
EOF
```
## 安装mariadb
```bash
yum install MariaDB-server MariaDB-client -y
```
## 登录mariadb数据库，创建新用户gogs
```bash
CREATE DATABASE gogs CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

```
https://dl.gogs.io/0.11.91/gogs_0.11.91_linux_amd64.tar.gz
https://blog.csdn.net/coding_ss/article/details/90267235
