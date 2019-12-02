#  linux根据进程号PID查找启动程序的全路径

### 方法一：找到某进程启动路径的方法是:

* 1.我们可以从ps命令中得到进程的PID,如34258。

* 2.进入/proc目录下以该PID命名的目录。

* 3.输入ls -ail,结果中exe链接对应的就是可执行文件的全路经详细信息。

```bash
[root@eifjsdofewfsdd /] cd /proc/34258
```

### 方法二：

```bash
lsof -p PID
```
