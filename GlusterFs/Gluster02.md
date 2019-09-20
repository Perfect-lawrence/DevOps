# GlusterFS分布式存储-02
### 复制卷  Replicated Glusterfs Volume

* 所有节点都需执行

```bash
[root@gluster01 mnt]# mkdir /data/gluster01/replica_data
```

* 创建一个复制卷
 

```bash
[root@gluster01 mnt]# gluster
Welcome to gluster prompt, type 'help' to see the available commands.
gluster> volume create help

Usage:
volume create <NEW-VOLNAME> [stripe <COUNT>] [replica <COUNT> [arbiter <COUNT>]] [disperse [<COUNT>]] [disperse-data <COUNT>] [redundancy <COUNT>] [transport <tcp|rdma|tcp,rdma>] <NEW-BRICK>... [force]

gluster volume create 卷名  replica 副本数 transport tcp 节点1IP:/xxx/xxx/  节点2IP:/xxx/xxx/ 

[root@gluster01 ~]# gluster volume create replica_data replica 4 transport tcp gluster01:/data/gluster01/replica_data gluster02:/data/gluster01/replica_data gluster03:/data/gluster01/replica_data gluster04:/data/gluster01/replica_data force
volume create: replica_data: success: please start the volume to access data

```
* 查看复制卷信息

```bash
[root@gluster01 ~]# gluster volume  info replica_data

Volume Name: replica_data
Type: Replicate
Volume ID: 002ce43f-b4c8-4686-85d1-733998609c82
Status: Started
Snapshot Count: 0
Number of Bricks: 1 x 4 = 4
Transport-type: tcp
Bricks:
Brick1: gluster01:/data/gluster01/replica_data
Brick2: gluster02:/data/gluster01/replica_data
Brick3: gluster03:/data/gluster01/replica_data
Brick4: gluster04:/data/gluster01/replica_data
Options Reconfigured:
transport.address-family: inet
nfs.disable: on
performance.client-io-threads: off
```

* 启动复制卷

```bash
[root@gluster01 ~]# gluster volume start volume_name
[root@gluster01 ~]# gluster volume start replica_data
volume start: replica_data: success
```
* 挂载测试 我在 gluster01 上测试

```bash
# 卸载之前的hash_data挂载的
[root@gluster01 ~]# umount -t glusterfs /mnt
[root@gluster01 ~]# mount -t glusterfs gluster01:replica_data /mnt
[root@gluster01 ~]# df -h
Filesystem               Size  Used Avail Use% Mounted on
.......
/dev/sdb                 2.0G   33M  2.0G   2% /data/gluster01
/dev/sdc                 2.0G   33M  2.0G   2% /data/gluster02
gluster01:replica_data   2.0G   53M  2.0G   3% /mnt
[root@gluster01 ~]# cd /mnt/
[root@gluster01 mnt]# touch relp{0..10}.txt
```
* 查看在各个节点的存储结果

```bash
# gluster01
[root@gluster01 mnt]# ls
relp0.txt   relp1.txt  relp3.txt  relp5.txt  relp7.txt  relp9.txt
relp10.txt  relp2.txt  relp4.txt  relp6.txt  relp8.txt

# gluster02
[root@gluster02 ~]# ls /data/gluster01/replica_data/
relp0.txt   relp1.txt  relp3.txt  relp5.txt  relp7.txt  relp9.txt
relp10.txt  relp2.txt  relp4.txt  relp6.txt  relp8.txt

# gluster03
[root@gluster03 ~]# ls /data/gluster01/replica_data/
relp0.txt   relp1.txt  relp3.txt  relp5.txt  relp7.txt  relp9.txt
relp10.txt  relp2.txt  relp4.txt  relp6.txt  relp8.txt

# gluster04
[root@gluster04 ~]# ls /data/gluster01/replica_data/
relp0.txt   relp1.txt  relp3.txt  relp5.txt  relp7.txt  relp9.txt
relp10.txt  relp2.txt  relp4.txt  relp6.txt  relp8.txt

```
* 总结：复制卷将克服分布式卷的数据丢失问题，其用于可靠的数据冗余
* 1)特点

- 该模式在所有的块服务器被保持一个精确的副本

- 卷的副本数量可由客户创建的时候决定

- 至少由两个块服务器或3个来创建一个卷

- 一个块服务故障仍然可从其他块服务器读取数据