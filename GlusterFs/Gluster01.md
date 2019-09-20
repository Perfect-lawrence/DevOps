# GlusterFS�ֲ�ʽ�洢-01
## ʲô��GlusterFS
* GlusterFS��GNU ClusterFile System����һ��ȫ�ԳƵĿ�Դ�ֲ�ʽ�ļ�ϵͳ����νȫ�Գ���ָGlusterFS���õ��Թ�ϣ�㷨��û�����Ľڵ㣬���нڵ�ȫ��ƽ��

## ���־������
* 1.Distributed���ֲ�ʽ�ģ�һ���ļ�����洢��һ����brick�ϣ��ļ����ܲ�֡���ʱvolume������������brick�ĺͣ�û�������̡�Ĭ���Ƿֲ�ʽ��

* 2.Replicated��1:1����ʽ��һ���ļ���ͬʱ�洢������brick�ϣ�һ���Ǵ洢һ���Ǳ��ݡ����Դ�ʱvolume�õ�������Ӧ��������brick�����͵�1/2��

* 3.Striped������ʽ����һ���ļ�����һ�����㷨�ֿ��洢�ںü���brick�ϡ����磺����һ���ļ��������д洢�ڵ�һ��brick�ϣ�ż���д洢�ڵڶ���brick�������ڸ߲��������з��ʷǳ�����ļ�ʱ��ʹ�ã�

* 4.Distributed Striped���ֲ�����ʽ��һ���ļ��Ȱ��շֲ�ʽ�ķ�ʽ(�ļ�����û�б���ɢ)�����һ����brick�У��������brick�У���������ʽ�ķ�ʽ���ļ����ݱ���ɢ��ţ������4��С��brick�С�

* 5.Distributed Replicated���ֲ�ʽ������һ���ļ��Ȱ��շֲ�ʽ���ļ�����û�б���ɢ�������һ����Brick�У�Ȼ���ְ��վ���ʽ���ļ�����û�б���ɢ����һ�������������С��brick�С�

* 6.Distributed Striped Replicated���ֲ�ʽ����ʽ����ʽ���ȷֲ�ʽ��Ȼ������ʽ���پ���ʽ

* 7.Striped Replicated������ʽ����ʽ��File�ļ������������gluster01��gluster02�У�gluster03��gluster04�е�������gluster01��gluster02���ݵ�һ������

* 8.Dispersed����ɢʽ������ʽ�������磬���ݱ�����10��brick�У�ÿ��brick��1T��10��brick����3������Ϊ����brick����Ϊ����У�飬�����洢����ʱvolumeֻ��7T��volume��������3��brick��

* 9.Distributed Dispersed���ֲ�ʽ��ɢ��Ч����ͬ�ڷֲ�ʽ���ƾ�ֻ�����Ӿ���ʹ�÷�ɢʽ�����Ǹ���ʽ

## Gluster�ճ�����



## GlusterFS�İ�װ
### ���𻷾�

* CentOS Linux release 7.6.1810 (Core)

* �ĸ��ڵ�

```markdown
������       IP
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
### �ĸ��ڵ���Ӷ���� 2�� 2GB���̣���ʽ��������

```bash
mkdir -pv /data/gluster{01,02} 
mkfs.xfs -f -i size=512 /dev/sdb
mkfs.xfs -f -i size=512 /dev/sdc
echo '/dev/sdb /data/gluster01 xfs defaults 1 2' >> /etc/fstab
echo '/dev/sdc /data/gluster02 xfs defaults 1 2' >> /etc/fstab
mount -a && mount
df -h 

```
## �ĸ��ڵ㰲װglusterFS

```bash
yum install centos-release-gluster glusterfs-server samba rpcbind glusterfs glusterfs-fuse glusterfs-rdma  -y

systemctl start glusterd.service
systemctl status glusterd.service
```
* ���뼯Ⱥ(���ĸ��ڵ����������)

```bash
[root@gluster01 data]# gluster peer probe gluster02
peer probe: success.
[root@gluster01 data]# gluster peer probe gluster03
peer probe: success.
[root@gluster01 data]# gluster peer probe gluster04
peer probe: success.

```
#### ��Ⱥ�������ϣ�����Ϳ������ʲô���ľ�洢������

* �鿴��Ⱥ״̬

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
