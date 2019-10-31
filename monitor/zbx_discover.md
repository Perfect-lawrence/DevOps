# zabbix自动发现与监控内存和CPU使用率最高的进程
#### 监控需求

* 某项目的应用服务器CPU和内存使用率的监控，通过zabbix系统监控记录应用服务器上进程的CPU和内存的使用情况，并以图表的形式实时展现，以便于我们分析服务器的性能瓶颈。

#### 监控方式

* 利用zabbix监控系统的自动发现功能，首先编写shell脚本获取服务器的CPU和内存资源使用率最大的进程，以json的格式输出，然后对这些进程的CPU和内存资源使用情况进行监控。（本文监控的进程为Linux服务器中资源使用率最高的10个进程。）

 

* 缺点

* 不适用于监控固定的进程


* 首先使用top命令查看进程状态，再取出进程的%CPU（该值表示单个CPU的进程从上次更新到现在的CPU时间占用百分比） 和%MEM值。

* 由于top是交互的命令，我们把top命令的结果输出到一个文件上

```bash
[lawrence@izwz99f5wnpdptfwcjrymmz monitor]$ top -b -n 1 > /tmp/.top.txt

```
* 第一个脚本，获取监控进程内存资源占有率前10的进程，输出格式为json格式，用于zabbix自动发现进程

```bash

# cat discovery_process.sh 
#!/bin/bash
#system process discovery script
top -b -n 1 > /tmp/.top.txt && chown zabbix. /tmp/.top.txt
proc_array=(`tail -n +8 /tmp/.top.txt | awk '{a[$NF]+=$10}END{for(k in a)print a[k],k}'|sort -gr|head -10|cut -d" " -f2`)
length=${#proc_array[@]}
  
printf "{\n"
printf '\t'"\"data\":["
for ((i=0;i<$length;i++))
do
    printf "\n\t\t{"
    printf "\"{#PROCESS_NAME}\":\"${proc_array[$i]}\"}"
    if [ $i -lt $[$length-1] ];then
        printf ","
    fi
done
    printf "\n\t]\n"
printf "}\n"

或者



# cat discovery_process2.sh 
#!/bin/bash
#system process discovery script
top -b -n 1 > /tmp/.top.txt && chown zabbix. /tmp/.top.txt
proc_array=`tail -n +8 /tmp/.top.txt | awk '{a[$NF]+=$10}END{for(k in a)print a[k],k}'|sort -gr|head -10|cut -d" " -f2`
  
length=`echo "${proc_array}" | wc -l`
count=0
echo '{'
echo -e '\t"data":['
echo "$proc_array" | while read line
do
    echo -en '\t\t{"{#PROCESS_NAME}":"'$line'"}'
    count=$(( $count + 1 ))
    if [ $count -lt $length ];then
        echo ','
    fi
done
echo -e '\n\t]'
echo '}'

```
* 输出效果如下：

```bash
[lawrence@izwz99f5wnpdptfwcjrymmz monitor]$ /bin/bash test.sh 
{
	"data":[
		{"{#PROCESS_NAME}":"apache2"},
		{"{#PROCESS_NAME}":"mysqld"},
		{"{#PROCESS_NAME}":"dockerd"},
		{"{#PROCESS_NAME}":"systemd-journal"},
		{"{#PROCESS_NAME}":"containerd"},
		{"{#PROCESS_NAME}":"sshd"},
		{"{#PROCESS_NAME}":"rsyslogd"},
		{"{#PROCESS_NAME}":"AliYunDun"},
		{"{#PROCESS_NAME}":"tuned"},
		{"{#PROCESS_NAME}":"bash"}
	]
}

```
* 第二个脚本，用于zabbix监控的具体监控项目（item）的key，通过脚本获取第一个脚本自动发现的进程的CPU和内存的具体使用情况与使用率。

```bash

#!/bin/bash
#system process CPU&MEM use information
#mail: mail@huangming.org
mode=$1
name=$2
process=$3
mem_total=$(cat /proc/meminfo | grep "MemTotal" | awk '{printf "%.f",$2/1024}')
cpu_total=$(( $(cat /proc/cpuinfo | grep "processor" | wc -l) * 100 ))
  
function mempre {
    mem_pre=`tail -n +8 /tmp/.top.txt | awk '{a[$NF]+=$10}END{for(k in a)print a[k],k}' | grep "\b${process}\b" | cut -d" " -f1`
    echo "$mem_pre"
}
  
function memuse {
    mem_use=`tail -n +8 /tmp/.top.txt | awk '{a[$NF]+=$10}END{for(k in a)print a[k]/100*'''${mem_total}''',k}' | grep "\b${process}\b" | cut -d" " -f1`
    echo "$mem_use" | awk '{printf "%.f",$1*1024*1024}'
}
  
function cpuuse {
    cpu_use=`tail -n +8 /tmp/.top.txt | awk '{a[$NF]+=$9}END{for(k in a)print a[k],k}' | grep "\b${process}\b" | cut -d" " -f1`
    echo "$cpu_use"
}
  
function cpupre {
    cpu_pre=`tail -n +8 /tmp/.top.txt | awk '{a[$NF]+=$9}END{for(k in a)print a[k]/('''${cpu_total}'''),k}' | grep "\b${process}\b" | cut -d" " -f1`
    echo "$cpu_pre"
}
  
  
case $name in
    mem)
        if [ "$mode" = "pre" ];then
            mempre
        elif [ "$mode" = "avg" ];then
            memuse
        fi
    ;;
    cpu)
        if [ "$mode" = "pre" ];then
            cpupre
        elif [ "$mode" = "avg" ];then
            cpuuse
        fi
    ;;
    *)
        echo -e "Usage: $0 [mode : pre|avg] [mem|cpu] [process]"
esac


```
*  查看一下当前系统的内存和CPU大小情况 

```bash
# mem
[lawrence@izwz99f5wnpdptfwcjrymmz monitor]$ cat /proc/meminfo | grep "MemTotal" | awk '{printf "%.f",$2/1024}'1839

# cpu
[lawrence@izwz99f5wnpdptfwcjrymmz monitor]$ cat /proc/cpuinfo | grep "processor" | wc -l
1
```
* 执行脚本运行效果如下（获取监控项key值）

[lawrence@izwz99f5wnpdptfwcjrymmz monitor]$ /bin/bash test2.sh avg mem dockerd
40494957
[lawrence@izwz99f5wnpdptfwcjrymmz monitor]$ /bin/bash test2.sh pre mem dockerd
2.1
[lawrence@izwz99f5wnpdptfwcjrymmz monitor]$ /bin/bash test2.sh cpu mem dockerd
[lawrence@izwz99f5wnpdptfwcjrymmz monitor]$ /bin/bash test2.sh cpu mem apache2
```

* 配置zabbix_agentd，在agentd客户端的etc/zabbix_agentd.conf中增加userparameter配置，增加进程自动发现的key，和进程资源检测的key。
* 配置完之后重启agentd服务

```bash
# vim etc/zabbix_agentd.conf.d/userparameter_script.conf
UserParameter=discovery.process,/opt/zabbix/scripts/test.sh
UserParameter=process.check[*],/opt/zabbix/scripts/test2.sh $1 $2 $3
```
* 在zabbix服务器端手动获取监控项key值数据
* 配置完agentd后，在zabbix服务器配置Web端的模版与监控项目item
* Configuration --> Templates --> Create template -->
* 创建完模版之后，添加自动发现规则
* Discovery rules -->Create discovesy rule
* Item prototypes --> Create item prototype
* 也可以继续添加监控的主机和所需监控项，添加完后我们可以查看下监控的历史数据
* 添加一个进程的CPU使用率的监控项
* 查看历史数据
* 当然还可以获取进程内存使用的具体大小情况
* 至此，zabbix自动发现进程内存和CPU使用情况并实时监控配置就完成了
```bash
# zabbix_get -p10050 -k 'discovery.process' -s 192.168.xxx.x


```

