###/etc/logrotate.d/nginx
###Nginx日志切割之Logrotate篇
```bash
/data/logs/nginx/all_logs/*.log {
    missingok
    notifempty
    sharedscripts
    delaycompress
    daily
    minsize 10M
    rotate 10
    olddir /data/logs/nginx/all_logs/
    dateext
    create 0600 root root
    postrotate
        [ -f /app/nginx/logs/nginx.pid ] && kill -USR1 `cat /app/nginx/logs/nginx.pid`
    endscript
}
```
