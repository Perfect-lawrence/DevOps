# 本文为您介绍云监控中内存使用率的计算方法。

* 在云监控中，内存的使用率计算公式如下：

* (mem_total - (mem_free + mem_buffer + mem_cache)) /mem_total

* 可以使用 cat /proc/meminfo命令检查mem_free， mem_buffer ， mem_cache的使用量。 例如：

```bash

[root@localhost ~]# cat /proc/meminfo MemTotal: 8011936 kBMemFree: 227336 kBBuffers: 277872 kBCached: 1451828 kB
```


* 计算方法：(8011936 - （227336 + 277872 + 1451828）) / 8011936

* 计算结果：内存使用率约等于 75%。

* 内存监控怎么做呢？很多人会说 free -m，怎么能够换算成百分比，而且去除cache的影响呢

```bash

mem=`free -m|grep Mem|awk '{print ($3-$6-$7)/$2}'`

```
* 服务器整体磁盘io监控
* 磁盘一般用iostat，笔者监控磁盘利用率一般使用iostat -x中的util指标

# 服务器整体cpu监控

* cpu指标监控在Linux中有很多实现方式，比如mpstat、top、包括vmstat中也有cpu的指标，但是哪个指标用来监控实时cpu利用率最合适呢？

* 答案是top，为什么呢，因为mpstat监测的是一段时间内的平均值，如果需要监测cpu均值的，可以采用这个指标，如果是瞬时值，top最合适

* 如何在top中截取呢，答案如下

```bash
cpuuse=`top -b -n2 -p 1 | fgrep "Cpu(s)" | tail -1 | awk -F'id,' -v prefix="$prefix" '{ split($1, vs, ","); v=vs[length(vs)]; sub("%", "", v); printf "%s%.1f%%\n", prefix, 100 - v }'`

[lawrence@izwz99f5wnpdptfwcjrymmz monitor]$ cpuuse=`top -b -n2 -p 1 | fgrep "Cpu(s)" | tail -1 | awk -F'id,' -v prefix="$prefix" '{ split($1, vs, ","); v=vs[length(vs)]; sub("%", "", v); printf "%s%.1f%%\n", prefix, 100 - v }'`
[lawrence@izwz99f5wnpdptfwcjrymmz monitor]$ echo $cpuuse
1.7%
```
* 为什么这么复杂呢，因为直接top|grep的话，可以发现每次截取出来的都一样，是有问题的，上面是最终的解决方案
