#!/bin/bash
# author_='xiangxiaohai@paojiao.cn'
# 此脚本是秒级别清空一个目录
#/usr/bin/rsync -r --delete /data/cdnlogs/test_2/kong/ /data/cdnlogs/test_2/"$@"/
if [ ! -d /data/cdnlogs/kong ]; then
    mkdir -v /data/cdnlogs/kong
fi
if [ -d /tmp/flush_dir ]; then
# 清空上次移动到/tmp/flush_dir/的所有空目录
   /usr/bin/rsync -r --delete --human-readable --progress /data/cdnlogs/kong/ /tmp/flush_dir/
else
    mkdir -v /tmp/flush_dir
fi

#删除10天前目录下所有文件
find /data/cdnlogs/ -type d -mtime +10 -exec /usr/bin/rsync -r --delete --human-readable --progress /data/cdnlogs/kong/ {} \;

# 将/data/cdnlogs/目录下的所有空目录移动到/tmp/flush_dir/目录下
find /data/cdnlogs/ -type d -empty -exec mv -v {} /tmp/flush_dir/ \;


#for duo in "$@"
#do
# /usr/bin/rsync -r --delete --human-readable --progress /data/cdnlogs/test_2/kong/ /data/cdnlogs/test_2/"$duo"/
#mv -v /data/cdnlogs/test_2/"$duo"/ /tmp/flush_dir/
#/usr/bin/rsync -r --delete --human-readable --progress /data/cdnlogs/test_2/kong/ /tmp/flush_dir/
#done
# 此脚本是秒级别清空一个目录
#find /data/cdnlogs/ -type d -mtime +7 -exec ls -d {} \;
#if [ ! -d /data/cdnlogs/test_dir ]; then
#    mkdir -v /data/cdnlogs/test_dir
#fi
#mkdir -v /data/cdnlogs/2017080{21,22,23,24,25,26,27,28,29}
#mkdir -v /data/cdnlogs/2017080{1,2,3,4,5,6}
#sleep 60
#find /data/cdnlogs/ -type d -mtime +10 -exec /usr/bin/rsync -r --delete /data/cdnlogs/test_dir/ {} \;
#find /data/cdnlogs/ -type d -empty -exec rmdir {} \;

