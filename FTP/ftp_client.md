# 客户端
安装lftp软件
============

```
yum install lftp -y

```

* 报错id解析：
   - 500 ##文件系统权限过大
   - 530 ##用户认证失败
   - 550 ##服务本身功能未开放
   - 553 ##本地文件系统权限太小

lftp的使用
==========

```
lftp --help
Usage: lftp [OPTS] <site>
`lftp' is the first command executed by lftp after rc files
 -f <file>           execute commands from the file and exit
 -c <cmd>            execute the commands and exit
 --help              print this help and exit
 --version           print lftp version and exit
Other options are the same as in `open' command
 -e <cmd>            execute the command just after selecting
 -u <user>[,<pass>]  use the user/password for authentication
 -p <port>           use the port for connection
 <site>              host name, URL or bookmark name

lftp -u username -p port ftp_server_ip
Password:  //提示输入密码

```

登录成功上传完文件
==================

```
lftp Username@ftp_server_ip:/> help
    !<shell-command>                     (commands)
    alias [<name> [<value>]]             attach [PID]                         bookmark [SUBCMD]
    cache [SUBCMD]                       cat [-b] <files>                     cd <rdir>
    chmod [OPTS] mode file...            close [-a]
    [re]cls [opts] [path/][pattern]      debug [<level>|off] [-o <file>]      du [options] <dirs>
    exit [<code>|bg]                     get [OPTS] <rfile> [-o <lfile>]
    glob [OPTS] <cmd> <args>             help [<cmd>]
    history -w file|-r file|-c|-l [cnt]  jobs [-v] [<job_no...>]              kill all|<job_no>
    lcd <ldir>                           lftp [OPTS] <site>
    ln [-s] <file1> <file2>              ls [<args>]                          mget [OPTS] <files>
    mirror [OPTS] [remote [local]]       mkdir [-p] <dirs>                    module name [args]
    more <files>                         mput [OPTS] <files>                  mrm <files>
    mv <file1> <file2>                   [re]nlist [<args>]                   open [OPTS] <site>
    pget [OPTS] <rfile> [-o <lfile>]     put [OPTS] <lfile> [-o <rfile>]      pwd [-p]
    queue [OPTS] [<cmd>]                 quote <cmd>
    repeat [OPTS] [delay] [command]      rm [-r] [-f] <files>                 rmdir [-f] <dirs>
    scache [<session_no>]                set [OPT] [<var> [<val>]]            site <site-cmd>
    source <file>                        torrent [-O <dir>] <file|URL>...
    user <user|URL> [<pass>]             wait [<jobno>]                       zcat <files>
    zmore <files>


```

