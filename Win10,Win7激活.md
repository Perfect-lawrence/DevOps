Win10,Win7激活
=====

* 右击桌面的左下角的“Windows”图标（win + r），从其右键菜单中选择“命令提示符（管理员）”项，以便打开 MSDOS界面。


- 卸载过期的密钥
```
slmgr.vbs /upk
```
- 安装密钥
```
slmgr /ipk 密钥
```

- 设置计算机名
```
slmgr /skms zh.us.to
```
- 联机自动激活
```
slmgr /ato

```
