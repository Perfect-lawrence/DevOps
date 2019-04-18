#  NFS介绍 v3 & v4
* [NFS各个版本之间的比较](#NFS各个版本之间的比较)
*  NFS是一种网络文件系统，从1985年推出至今，共发布了3个版本：NFSv2、NFSv3、NFSv4，NFSv4包含两个次版本NFSv4.0和NFSv4.1。经过20多年发展，NFS发生了非常大的变化，最大的变化就是推动者从Sun变成了NetApp，NFSv2和NFSv3基本上是Sun起草的，NetApp从NFSv4.0参与进来，并且主导了NFSv4.1标准的制定过程，而Sun已经被Oracle收购了。


<table>
        <tr>
            <th>编号</th>
            <th>版本</th>
            <th>RFC</th>
            <th> 时间</th>
            <th> 页数</th>
        </tr>
        <tr>
            <th>1</th>
            <th>NFSv2</th>
            <th>rfc1094</th>
            <th>1989年3月</th>
            <th>27页 </th>
        </tr>
        <tr>
            <th>2</th>
            <th>NFSv3</th>
            <th>rfc1813</th>
            <th>1995年6月</th>
             <th>126页 </th>
        </tr>
        <tr>
            <th>3</th>
            <th>NFSv4.0</th>
            <th>rfc3530</th>
            <th>2003年4月</th>
             <th>275页 </th>
        </tr>
        <tr>
            <th>4</th>
            <th>NFSv4.1</th>
            <th>rfc5661</th>
            <th>2010年1月</th>
             <th> 617页</th>
        </tr>
   </table>
    
#  NFSv2

NFSv2是第一个以RFC形式发布的版本，实现了基本的功能。


#  NFSv3

* NFSv3是1995年发布的，这时NFSv2已经发布了6年了，NFSv3修正了NFSv2的一些bug。两者有如下一些差别，但是感觉没有本质的差别。

* (1) NFSv2对每次读写操作中传输数据的最大长度进行了限制，上限值为8192字节，NFSv3取消了这个限制。

* (2) NFSv3对文件名称长度进行了限制，上限值为255字节，NFSv3取消了这个限制。

* (3) NFSv2对文件长度进行了限制，上限值为0x7FFFFFFF，NFSv3取消了这个限制。

* (4) NFSv2中文件句柄长度固定为32字节，NFSv3中文件句柄长度可变，上限值是64字节。

* (5) NFSv2只支持同步写，如果客户端向服务器端写入数据，服务器必须将数据写入磁盘中才能发送应答消息。NFSv3支持异步写操作，服务器只需要将数据写入缓存中就可以发送应答信息了。NFSv3增加了COMMIT请求，COMMIT请求可以将服务器缓存中的数据刷新到磁盘中。

* (6) NFSv3增加了ACCESS请求，ACCESS用来检查用户的访问权限。因为服务器端可能进行uid映射，因此客户端的uid和gid不能正确反映用户的访问权限。NFSv2的处理方法是不管访问权限，直接返送请求，如果没有访问权限就出错。NFSv3中增加了ACCESS请求，客户端可以检查是否有访问权限。

* (7) 一些请求调整了参数和返回信息，毕竟NFSv3和NFSv2发布的间隔有6年，经过长期运行可能觉得NFSv2某些请求参数和返回信息需要改进。


#  NFSv4.0

* 相比NFSv3，NFSv4发生了比较大的变化，最大的变化是NFSv4有状态了。NFSv2和NFSv3都是无状态协议，服务区端不需要维护客户端的状态信息。无状态协议的一个优点在于灾难恢复，当服务器出现问题后，客户端只需要重复发送失败请求就可以了，直到收到服务器的响应信息。但是某些操作必须需要状态，如文件锁。如果客户端申请了文件锁，但是服务器重启了，由于NFSv3无状态，客户端再执行锁操作可能就会出错了。NFSv3需要NLM协助才能实现文件锁功能，但是有的时候两者配合不够协调。NFSv4设计成了一种有状态的协议，自身实现了文件锁功能，就不需要NLM协议了。NFSv4和NFSv3的差别如下：

* (1) NFSv4设计成了一种有状态的协议，自身实现了文件锁功能和获取文件系统根节点功能，不需要NLM和MOUNT协议协助了。

* (2) NFSv4增加了安全性，支持RPCSEC-GSS身份认证。

* (3) NFSv4只提供了两个请求NULL和COMPOUND，所有的操作都整合进了COMPOUND中，客户端可以根据实际请求将多个操作封装到一个COMPOUND请求中，增加了灵活性。

*  (4) NFSv4文件系统的命令空间发生了变化，服务器端必须设置一个根文件系统(fsid=0)，其他文件系统挂载在根文件系统上导出。

* (5) NFSv4支持delegation。由于多个客户端可以挂载同一个文件系统，为了保持文件同步，NFSv3中客户端需要经常向服务器发起请求，请求文件属性信息，判断其他客户端是否修改了文件。如果文件系统是只读的，或者客户端对文件的修改不频繁，频繁向服务器请求文件属性信息会降低系统性能。NFSv4可以依靠delegation实现文件同步。当客户端A打开一个文件时，服务器会分配给客户端A一个delegation。只要客户端A具有delegation，就可以认为与服务器保持了一致。如果另外一个客户端B访问同一个文件，则服务器会暂缓客户端B的访问请求，向客户端A发送RECALL请求。当客户端A接收到RECALL请求时将本地缓存刷新到服务器中，然后将delegation返回服务器，这时服务器开始处理客户端B的请求。

* (6) NFSv4修改了文件属性的表示方法。由于NFS是Sun开发的一套文件系统，设计之出NFS文件属性参考了UNIX中的文件属性，可能Windows中不具备某些属性，因此NFS对操作系统的兼容性不太好。NFSv4将文件属性划分成了三类：

* Mandatory Attributes: 这是文件的基本属性，所有的操作系统必须支持这些属性。

* Recommended Attributes: 这是NFS建议的属性，如果可能操作系统尽量实现这些属性。

* Named Attributes: 这是操作系统可以自己实现的一些文件属性。


#  NFSv4.1

* 与NFSv4.0相比，NFSv4.1最大的变化是支持并行存储了。在以前的协议中，客户端直接与服务器连接，客户端直接将数据传输到服务器中。当客户端数量较少时这种方式没有问题，但是如果大量的客户端要访问数据时，NFS服务器很快就会成为一个瓶颈，抑制了系统的性能。NFSv4.1支持并行存储，服务器由一台元数据服务器(MDS)和多台数据服务器(DS)构成，元数据服务器只管理文件在磁盘中的布局，数据传输在客户端和数据服务器之间直接进行。由于系统中包含多台数据服务器，因此数据可以以并行方式访问，系统吞吐量迅速提升。  