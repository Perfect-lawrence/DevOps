# cpu监控利器

* mpstat是Multiprocessor Statistics的缩写，是实时系统监控工具。其报告与CPU的一些统计信息，这些信息存放在/proc/stat文件中。在多CPUs系统里，其不但能查看所有CPU的平均状况信息，而且能够查看特定CPU的信息。mpstat最大的特点是：可以查看多核心cpu中每个计算核心的统计数据；而类似工具vmstat只能查看系统整体cpu情况。

* 二 用法
   mpstat [-P {|ALL}] [internal [count]]
   参数解释
   -P {|ALL} 表示监控哪个CPU， cpu在[0,cpu个数-1]中取值，比如要查看编号 8,15的cpu 则执行 mpstat -P 8,15 
   internal 相邻的两次采样的间隔时间、
   count 采样的次数，count只能和delay一起使用
当没有参数时，mpstat则显示系统启动以后所有信息的平均值。有interval时，第一行的信息自系统启动以来的平均信息。从第二行开始，输出为前一个interval时间段的平均信息。

```bash

[lawrence@izwz99f5wnpdptfwcjrymmz monitor]$ mpstat -P ALL 2
Linux 3.10.0-862.14.4.el7.x86_64 (izwz99f5wnpdptfwcjrymmz) 	10/31/2019 	_x86_64_	(1 CPU)

03:41:08 PM  CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal  %guest  %gnice   %idle
03:41:10 PM  all    0.51    0.00    0.51    0.00    0.00    0.00    0.00    0.00    0.00   98.98
03:41:10 PM    0    0.51    0.00    0.51    0.00    0.00    0.00    0.00    0.00    0.00   98.98

03:41:10 PM  CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal  %guest  %gnice   %idle
03:41:12 PM  all    0.51    0.00    0.51    0.00    0.00    0.00    0.00    0.00    0.00   98.98
03:41:12 PM    0    0.51    0.00    0.51    0.00    0.00    0.00    0.00    0.00    0.00   98.98

03:41:12 PM  CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal  %guest  %gnice   %idle
03:41:14 PM  all    0.51    0.00    1.02    0.00    0.00    0.00    0.00    0.00    0.00   98.48
03:41:14 PM    0    0.51    0.00    1.02    0.00    0.00    0.00    0.00    0.00    0.00   98.48


03:41:14 PM  CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal  %guest  %gnice   %idle
03:41:16 PM  all    0.51    0.00    0.51    0.00    0.00    0.00    0.00    0.00    0.00   98.98
03:41:16 PM    0    0.51    0.00    0.51    0.00    0.00    0.00    0.00    0.00    0.00   98.98
^C

Average:     CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal  %guest  %gnice   %idle
Average:     all    0.51    0.00    0.64    0.00    0.00    0.00    0.00    0.00    0.00   98.86
Average:       0    0.51    0.00    0.64    0.00    0.00    0.00    0.00    0.00    0.00   98.86
```

* 字段的含义如下:

```markdown

%user   在internal时间段里，用户态的CPU时间(%)，不包含nice值为负进程 (usr/total)*100
 
%nice   在internal时间段里，nice值为负进程的CPU时间(%) (nice/total)*100

%sys    在internal时间段里，内核时间(%) (system/total)*100

%iowait 在internal时间段里，硬盘IO等待时间(%) (iowait/total)*100

%irq    在internal时间段里，硬中断时间(%) (irq/total)*100

%soft   在internal时间段里，软中断时间(%) (softirq/total)*100

%idle   在internal时间段里，CPU除去等待磁盘IO操作外的因为任何原因而空闲的时间闲置时间(%) (idle/total)*10
```
