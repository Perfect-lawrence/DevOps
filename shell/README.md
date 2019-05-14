# Shell基础知识和编程规范
======================

SHELL官方文档：
-------------

Links:
------
* Website: http://www.gnu.org/software/bash/manual/bash.html


* 查看系统Shell支持情况



```
[lawrence@izwz99f5wnpdptfwcjrymmz ~]$ man bash  
[lawrence@izwz99f5wnpdptfwcjrymmz ~]$ cat /etc/shells 
/bin/sh
/bin/bash
/sbin/nologin
/usr/bin/sh
/usr/bin/bash
/usr/sbin/nologin
```

* 当前系统使用的默认shell

```
[lawrence@izwz99f5wnpdptfwcjrymmz ~]$ echo $SHELL          
/bin/bash

[lawrence@izwz99f5wnpdptfwcjrymmz ~]$ grep "lawrence" /etc/passwd
lawrence:x:1000:1000::/home/lawrence:/bin/bash

```

脚本开通（第一行）
---------------
* 一个规范的Shell脚本在第一行会指出由哪个程序（解释器）来执行脚本中的内容，这一行内容在Linux bash的编程一般为

```
#!/bin/bash
或
#!/bin/sh
```

bash与sh的区别
---------------
```
[lawrence@izwz99f5wnpdptfwcjrymmz ~]$ ls /bin/bash  -l
-rwxr-xr-x 1 root root 964544 Apr 11  2018 /bin/bash
[lawrence@izwz99f5wnpdptfwcjrymmz ~]$ ls /bin/sh  -l                         # sh为bash的软连接
lrwxrwxrwx 1 root root 4 Nov  2  2018 /bin/sh -> bash

```

* bash 版本

```
[lawrence@izwz99f5wnpdptfwcjrymmz ~]$ bash --version
GNU bash, version 4.2.46(2)-release (x86_64-redhat-linux-gnu)
Copyright (C) 2011 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>

This is free software; you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

```

* 测试bash是否有破壳漏洞，如果返回be careful，则表示需要尽快升级bash了

```
[lawrence@izwz99f5wnpdptfwcjrymmz ~]$ env x='() { :;}; echo be careful' bash -c "echo this is a test"   # 提示：如果没有输出be careful，则不需要升级
this is a test
[lawrence@izwz99f5wnpdptfwcjrymmz ~]$ sudo yum -y update bash             
```
脚本注释
---------------
*在Shell脚本中， #   后面的内容表示注释，开发脚本时，如果没有注释，那么团队里的其他人就会很难理解加班对应内容的用途，而且时间长了自己也会忘记。
为了方便别人和方便自己，避免影响团队的协助效率，要养成一个写关机注释的习惯。脚本注释尽量不要用中文，避免乱码问题

Shell脚本的执行
---------------
* 当Shell脚本运行时，它会先查找系统环境变量ENV，改变量指定了环境文件，
* 加载顺利通车是/etc/profile ---> ~/.bash_profile ---> ~/.bashrc --->/etc/bashrc等，在加载了上述的环境变量文件后，Shell就开始执行脚本中的内容

* bash 脚本名 或sh 脚本名 建议以  xxxxx.sh 结尾

```
[lawrence@izwz99f5wnpdptfwcjrymmz ~]$ cat test.sh 
#!/bin/bash
echo "arguments number: $#"
echo "current script name: $0"
echo "first  arguments: $1"
echo "second arguments: $2"
echo "third  arguments: $3"
echo "forth  arguments: $4"
echo "arguments list: $@" 
echo "\$* arguments list : $* "
echo "exit code: $?"
echo " \$\$ : $$"

```

* 使用脚本的绝对路径执行 或相对路径 ./脚本名 这个需要有文件的执行权限

```
[lawrence@izwz99f5wnpdptfwcjrymmz ~]$ chmod 755 test.sh
[lawrence@izwz99f5wnpdptfwcjrymmz ~]$ /bin/bash /home/lawrence/test.sh
[lawrence@izwz99f5wnpdptfwcjrymmz ~]$ sh /home/lawrence/test.sh 
```

* 使用source导入子脚本的环境变量到当前环境就可以获取子脚本的变量

```
[lawrence@izwz99f5wnpdptfwcjrymmz ~]$ source login_user.sh 
[lawrence@izwz99f5wnpdptfwcjrymmz ~]$ echo $username
lawrence
[lawrence@izwz99f5wnpdptfwcjrymmz ~]$ cat login_user.sh 
#!/bin/bash
username=$(whoami)
```
