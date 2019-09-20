# GlusterFS分布式存储-01
## 什么是GlusterFS
* GlusterFS（GNU ClusterFile System）是一种全对称的开源分布式文件系统，所谓全对称是指GlusterFS采用弹性哈希算法，没有中心节点，所有节点全部平等

## 九种卷的类型
* 1.Distributed：分布式的，一个文件随机存储在一个的brick上，文件不能拆分。此时volume的容量是所有brick的和，没有冗余盘。默认是分布式的

* 2.Replicated：1:1备份式，一个文件会同时存储在两个brick上，一个是存储一个是备份。所以此时volume得到的容量应该是所有brick容量和的1/2。

* 3.Striped：条带式，把一个文件按照一定的算法分开存储在好几个brick上。比如：对于一个文件，奇数行存储在第一个brick上，偶数行存储在第二个brick。（仅在高并发环境中访问非常大的文件时才使用）

* 4.Distributed Striped：分布条带式，一个文件先按照分布式的方式(文件数据没有被拆散)存放在一个大brick中，在这个大brick中，再用条带式的方式（文件数据被分散存放）存放在4个小的brick中。

* 5.Distributed Replicated：分布式副本卷，一个文件先按照分布式（文件数据没有被拆散）存放在一个大Brick中，然后又按照镜像式（文件数据没有被拆散，有一个副本）存放在小的brick中。

* 6.Distributed Striped Replicated：分布式条带式复制式，先分布式，然后条带式，再镜像式

* 7.Striped Replicated：条带式副本式，File文件被打撒存放在gluster01和gluster02中，gluster03和gluster04中的数据是gluster01和gluster02数据的一个备份

* 8.Dispersed：分散式（冗余式），例如，数据保存在10个brick中，每个brick有1T，10个brick中有3个是作为冗余brick，作为数据校验，不做存储。此时volume只有7T，volume中允许有3个brick损坏

* 9.Distributed Dispersed：分布式分散卷，效果等同于分布式复制卷，只不过子卷是使用分散式而不是复制式

## Gluster日常操作



## GlusterFS的安装
### 部署环境

* CentOS Linux release 7.6.1810 (Core)

* 四个节点

```markdown
主机名       IP
192.168.203.11 gluster01
192.168.203.12 gluster02
192.168.203.13 gluster03
192.168.203.14 gluster04
```
```bash
cat /etc/hosts
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
192.168.203.11 gluster01
192.168.203.12 gluster02
192.168.203.13 gluster03
192.168.203.14 gluster04
```
### 四个节点添加都添加 2块 2GB磁盘，格式化并挂载

```bash
mkdir -pv /data/gluster{01,02} 
mkfs.xfs -f -i size=512 /dev/sdb
mkfs.xfs -f -i size=512 /dev/sdc
echo '/dev/sdb /data/gluster01 xfs defaults 1 2' >> /etc/fstab
echo '/dev/sdc /data/gluster02 xfs defaults 1 2' >> /etc/fstab
mount -a && mount
df -h 

```
## 四个节点安装glusterFS

```bash
yum install centos-release-gluster glusterfs-server samba rpcbind glusterfs glusterfs-fuse glusterfs-rdma  -y

systemctl start glusterd.service
systemctl status glusterd.service
```
* 加入集群(在哪个节点操作，随意)

```bash
[root@gluster01 data]# gluster peer probe gluster02
peer probe: success.
[root@gluster01 data]# gluster peer probe gluster03
peer probe: success.
[root@gluster01 data]# gluster peer probe gluster04
peer probe: success.

```
#### 集群环境搭建完毕，下面就看你采用什么样的卷存储类型了

* 查看集群状态

```bash
# on gluster01
[root@gluster01 data]# gluster peer status
Number of Peers: 3

Hostname: gluster02
Uuid: fc9ec0d9-8014-465a-bc98-4b2e1a511b04
State: Peer in Cluster (Connected)

Hostname: gluster03
Uuid: 778e1aaf-2f5d-44af-bbc1-66434d368743
State: Peer in Cluster (Connected)

Hostname: gluster04
Uuid: 0b536231-b6f0-4ad0-931e-9382751c0afc
State: Peer in Cluster (Connected)

# on gluster02 
[root@gluster02 yum.repos.d]# gluster peer status
Number of Peers: 3

Hostname: gluster01
Uuid: ced6ea7c-5a15-42ea-adfe-c91d4a7abbfa
State: Peer in Cluster (Connected)

Hostname: gluster03
Uuid: 778e1aaf-2f5d-44af-bbc1-66434d368743
State: Peer in Cluster (Connected)

Hostname: gluster04
Uuid: 0b536231-b6f0-4ad0-931e-9382751c0afc
State: Peer in Cluster (Connected)

```
