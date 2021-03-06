VMware command
====

## 查看帮助

```
[root@elk xiangxh]# vmrun -help
Invalid argument: -help
vmrun version 1.17.0 build-8497320

Usage: vmrun [AUTHENTICATION-FLAGS] COMMAND [PARAMETERS]



AUTHENTICATION-FLAGS
--------------------
These must appear before the command and any command parameters.

   -T <hostType> (ws|fusion||player)
   -vp <password for encrypted virtual machine>
   -gu <userName in guest OS>
   -gp <password in guest OS>



POWER COMMANDS           PARAMETERS           DESCRIPTION
--------------           ----------           -----------
start                    Path to vmx file     Start a VM or Team
                         [gui|nogui]

stop                     Path to vmx file     Stop a VM or Team
                         [hard|soft]

reset                    Path to vmx file     Reset a VM or Team
                         [hard|soft]

suspend                  Path to vmx file     Suspend a VM or Team
                         [hard|soft]

pause                    Path to vmx file     Pause a VM

unpause                  Path to vmx file     Unpause a VM



SNAPSHOT COMMANDS        PARAMETERS           DESCRIPTION
-----------------        ----------           -----------
listSnapshots            Path to vmx file     List all snapshots in a VM
                         [showTree]

snapshot                 Path to vmx file     Create a snapshot of a VM
                         Snapshot name

deleteSnapshot           Path to vmx file     Remove a snapshot from a VM
                         Snapshot name
                         [andDeleteChildren]

revertToSnapshot         Path to vmx file     Set VM state to a snapshot
                         Snapshot name



GUEST OS COMMANDS        PARAMETERS           DESCRIPTION
-----------------        ----------           -----------
runProgramInGuest        Path to vmx file     Run a program in Guest OS
                         [-noWait]
                         [-activeWindow]
                         [-interactive]
                         Complete-Path-To-Program
                         [Program arguments]

fileExistsInGuest        Path to vmx file     Check if a file exists in Guest OS
                         Path to file in guest

directoryExistsInGuest   Path to vmx file     Check if a directory exists in Guest OS
                         Path to directory in guest

setSharedFolderState     Path to vmx file     Modify a Host-Guest shared folder
                         Share name
                         Host path
                         writable | readonly

addSharedFolder          Path to vmx file     Add a Host-Guest shared folder
                         Share name
                         New host path

removeSharedFolder       Path to vmx file     Remove a Host-Guest shared folder
                         Share name

enableSharedFolders      Path to vmx file     Enable shared folders in Guest
                         [runtime]

disableSharedFolders     Path to vmx file     Disable shared folders in Guest
                         [runtime]

listProcessesInGuest     Path to vmx file     List running processes in Guest OS

killProcessInGuest       Path to vmx file     Kill a process in Guest OS
                         process id

runScriptInGuest         Path to vmx file     Run a script in Guest OS
                         [-noWait]
                         [-activeWindow]
                         [-interactive]
                         Interpreter path
                         Script text

deleteFileInGuest        Path to vmx file     Delete a file in Guest OS
                         Path in guest            

createDirectoryInGuest   Path to vmx file     Create a directory in Guest OS
                         Directory path in guest  

deleteDirectoryInGuest   Path to vmx file     Delete a directory in Guest OS
                         Directory path in guest  

CreateTempfileInGuest    Path to vmx file     Create a temporary file in Guest OS

listDirectoryInGuest     Path to vmx file     List a directory in Guest OS
                         Directory path in guest

CopyFileFromHostToGuest  Path to vmx file     Copy a file from host OS to guest OS
                         Path on host
                         Path in guest

CopyFileFromGuestToHost  Path to vmx file     Copy a file from guest OS to host OS
                         Path in guest
                         Path on host

renameFileInGuest        Path to vmx file     Rename a file in Guest OS
                         Original name
                         New name

typeKeystrokesInGuest    Path to vmx file     Type Keystrokes in Guest OS
                         keystroke string

connectNamedDevice       Path to vmx file     Connect the named device in the Guest OS
                         device name

disconnectNamedDevice    Path to vmx file     Disconnect the named device in the Guest OS
                         device name

captureScreen            Path to vmx file     Capture the screen of the VM to a local file
                         Path on host

writeVariable            Path to vmx file     Write a variable in the VM state
                         [runtimeConfig|guestEnv|guestVar]
                         variable name
                         variable value

readVariable             Path to vmx file     Read a variable in the VM state
                         [runtimeConfig|guestEnv|guestVar]
                         variable name

getGuestIPAddress        Path to vmx file     Gets the IP address of the guest
                         [-wait]



GENERAL COMMANDS         PARAMETERS           DESCRIPTION
----------------         ----------           -----------
list                                          List all running VMs

upgradevm                Path to vmx file     Upgrade VM file format, virtual hw

installTools             Path to vmx file     Install Tools in Guest

checkToolsState          Path to vmx file     Check the current Tools state

deleteVM                 Path to vmx file     Delete a VM

clone                    Path to vmx file     Create a copy of the VM
                         Path to destination vmx file
                         full|linked
                         [-snapshot=Snapshot Name]
                         [-cloneName=Name]



Template VM COMMANDS     PARAMETERS           DESCRIPTION
---------------------    ----------           -----------
downloadPhotonVM         Path for new VM      Download Photon VM





Examples:


Starting a virtual machine with Workstation on a Windows host
   vmrun -T ws start "c:\my VMs\myVM.vmx"


Running a program in a virtual machine with Workstation on a Windows host with Windows guest
   vmrun -T ws -gu guestUser -gp guestPassword runProgramInGuest "c:\my VMs\myVM.vmx" "c:\Program Files\myProgram.exe"


Creating a snapshot of a virtual machine with Workstation on a Windows host
   vmrun -T ws snapshot "c:\my VMs\myVM.vmx" mySnapshot


Reverting to a snapshot with Workstation on a Windows host
   vmrun -T ws revertToSnapshot "c:\my VMs\myVM.vmx" mySnapshot


Deleting a snapshot with Workstation on a Windows host
   vmrun -T ws deleteSnapshot "c:\my VMs\myVM.vmx" mySnapshot


Enabling Shared Folders with Workstation on a Windows host
   vmrun -T ws enableSharedFolders "c:\my VMs\myVM.vmx"


```
## 开启虚拟机

```
[root@elk xiangxh]# vmrun -T ws  start /data/VMware_v14.2/Node_11/Node_11.vmx nogui #虚拟机非图形界面启动

[root@elk xiangxh]# vmrun -T ws start /data/VMware_v14.2/node1/Kubernetes.vmx gui    # 图形界面启动(前提有安装的图形界面)

[root@elk xiangxh]# for i in {1,2,3};do vmrun -T ws start /data/Kubernetes_Docker/Server_$i/Server_$i.vmx nogui; sleep 5;done

```

## 关闭虚拟机

```
[root@elk xiangxh]# vmrun -T ws  stop /data/VMware_v14.2/Node_11/Node_11.vmx
```
## 暂停虚拟机

```

```
## 强制关闭虚拟机

```
[root@elk xiangxh]# vmrun -T ws stop /data/VMware_v14.2/Node_11/Node_11.vmx 
```
## 查看在运行的虚拟机

```
[root@elk xiangxh]# vmrun -T ws list
```

## 删除虚拟机

```
[root@elk xiangxh]# vmrun -T ws deleteVM /data/VMware_v14.2/node3/node3.vmx
```

## 创建快照:snapshot

```
[root@elk xiangxh]# vmrun -T ws snapshot /data/VMware_v14.2/node1/Kubernetes.vmx snapshot_name
[root@elk xiangxh]#  for i in {2..5};do vmrun -T ws snapshot /data/VMware_v14.2/Node_$i/Node_$i.vmx system_init;done
[root@elk ssh_vmware_machine]# for i in {7..19};do vmrun -T ws snapshot /data/VMware_v14.2/Node_$i/Node_$i.vmx system_init;done

```

## 查看快照：snapshot

```
[root@elk xiangxh]# vmrun listSnapshots /data/VMware_v14.2/node1/Kubernetes.vmx
Total snapshots: 2
system_init
Kubernetes_master
[root@elk ssh_vmware_machine]# vmrun -T ws listSnapshots /data/VMware_v14.2/Node_6/Node_6.vmx
Total snapshots: 1
system_init
[root@elk ssh_vmware_machine]# for i in {1..5};do vmrun -T ws listSnapshots /data/VMware_v14.2/Node_$i/Node_$i.vmx;done
[root@elk ssh_vmware_machine]# for i in {7..19};do vmrun -T ws listSnapshots /data/VMware_v14.2/Node_$i/Node_$i.vmx;done
```

## 恢复到快照:snapshot

```
[root@elk xiangxh]# vmrun -T ws revertToSnapshot /data/VMware_v14.2/node1/Kubernetes.vmx system_init
[root@elk xiangxh]# for i in {1,2,3};do vmrun -T ws revertToSnapshot /data/Kubernetes_Docker/Server_$i/Server_$i.vmx system_init;done
```

## 删除快照:snapshot

```
[root@elk xiangxh]# vmrun -T ws deleteSnapshot /data/VMware_v14.2/node1/Kubernetes.vmx Kubernetes_master
```

##  以这个 /data/VMware_v14.2/node1/Kubernetes.vmx 虚拟机文件,克隆一个完整的新的虚拟机   

```
[root@elk xiangxh]# mkdir -v /data/VMware_v14.2/node{2,3}
[root@elk xiangxh]# vmrun -T ws clone /data/VMware_v14.2/node1/Kubernetes.vmx  /data/VMware_v14.2/node2/node2.vmx full -cloneName=node2

[root@elk xiangxh]# vmrun -T ws clone /data/VMware_v14.2/node1/Kubernetes.vmx  /data/VMware_v14.2/node3/node3.vmx linked -snapshot=system_init -cloneName=node3

for num in {7..19}; do vmrun -T ws clone /data/VMware_v14.2/Node_20/Node_20.vmx  /data/VMware_v14.2/Node_${num}/Node_${num}.vmx full -cloneName=Node_${num}; sleep 10; done
```



