#!/bin/bash
# author_ = 'xiangxiaohai@paojiao.cn'

case $1 in
 p|processlist)
        /app/mysqld/bin/mysqladmin --user=root --host=localhost --socket=/tmp/mysql.sock --port=3388 --password processlist
;;
 v|variables)
        /app/mysqld/bin/mysqladmin --user=root --host=localhost --socket=/tmp/mysql.sock --port=3388 --password variables
;;
 s|status)
        /app/mysqld/bin/mysqladmin --user=root --host=localhost --socket=/tmp/mysql.sock --port=3388 --password status
;;
 t|Threads_connected)
        ###/app/mysqld/bin/mysql --user=root --host=localhost --socket=/tmp/mysql.sock --port=3388 --password --execute="show status like '%Threads_connected%'\G;"#####|awk -F':' '/Value/ {print $NF}'
        /app/mysqld/bin/mysql --user=root --host=localhost --socket=/tmp/mysql.sock --port=3388 --password --execute="show status like '%Threads_connected%';"
;;
 th|Threads_running)
        ###/app/mysqld/bin/mysql --user=root --host=localhost --socket=/tmp/mysql.sock --port=3388 --password --execute="show status like '%Threads_running%'\G;"######|awk -F ':' '/Value/ {print $NF}'
        /app/mysqld/bin/mysql --user=root --host=localhost --socket=/tmp/mysql.sock --port=3388 --password --execute="show status like '%Threads_running%';"
;;
 *|--help)
        echo "$Usage: $0 { p(processlist) | s(status) | v(variables) | t(Threads_connected) | th(Threads_running) } "
        exit 2
;;
esac
exit $?
