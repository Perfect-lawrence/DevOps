# shell中$0,$?,$!,$$,$*,$#,$@等的特殊用法

* 变量说明:

```
$$     # Shell本身的PID（ProcessID）
```
```
$!      # Shell最后运行的后台Process的PID
```
```
$?      # 最后运行的命令的结束代码（返回值）
```
```
$-       #使用Set命令设定的Flag一览
```
```
$*       #所有参数列表。如"$*"用「"」括起来的情况、以"$1 $2 … $n"的形式输出所有参数。
```
```
$@       # 所有参数列表。如"$@"用「"」括起来的情况、以"$1" "$2" … "$n" 的形式输出所有参数。
```
```
$#       #添加到Shell的参数个数
```
```
$0        # Shell本身的文件名
```
```
$1～$n    #  添加到Shell的各参数值。$1是第1参数、$2是第2参数…。
```
# example

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
```
[lawrence@izwz99f5wnpdptfwcjrymmz ~]$ /bin/bash test.sh aa bb cc dd
arguments number: 4
current script name: test.sh
first  arguments: aa
second arguments: bb
third  arguments: cc
forth  arguments: dd
arguments list: aa bb cc dd
$* arguments list : aa bb cc dd 
exit code: 0
 $$ : 4474

```

# $* 和 $@ 的区别

* $* 和 $@ 都表示传递给函数或脚本的所有参数，不被双引号(" ")包含时，都以"$1" "$2" … "$n" 的形式输出所有参数。
但是当它们被双引号(" ")包含时，"$*" 会将所有的参数作为一个整体，以"$1 $2 … $n"的形式输出所有参数；"$@" 会将各个参数分开，以"$1" "$2" … "$n" 的形式输出所有参数。

```

```
# 总结：
```
$#  是传给脚本的参数个数
$0  是脚本本身的名字
$n  传递给脚本或函数的参数。n 是一个数字，表示第几个参数。例如，第一个参数是$1，第二个参数是$2。
$1  是传递给该shell脚本的第一个参数
$2  是传递给该shell脚本的第二个参数
$@  是传给脚本的所有参数的列表
$?  退出状态 ,也可以表示函数的返回值
$$  当前Shell进程ID。对于 Shell 脚本，就是这些脚本所在的进程ID。
$* 传递给脚本或函数的所有参数
$!  Shell最后运行的后台Process的PID

```
