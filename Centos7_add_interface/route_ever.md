# CentOS7添加永久静态路由
RHEL7官网文档没有提到 /etc/sysconfig/static-routes，经测试此文件已经无效
/etc/sysconfig/network 配置文件仅仅可以提供全局默认网关
永久静态路由需要写到 /etc/sysconfig/network-scripts/route-interfacename 文件中
```markdown
vi /etc/sysconfig/network-scripts/route-ens32
192.168.1.0/24 via 192.168.5.1 dev ens32
192.168.2.0/24 via 192.168.5.1 dev ens32
192.168.3.0/24 via 192.168.5.1 dev ens32

```
