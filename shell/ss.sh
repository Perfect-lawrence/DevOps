#!/bin/bash
echo "### ss    ########################################"
/usr/sbin/ss -ant | awk '{++s[$1]} END {for(k in s) print k,s[k]}'
echo "########   netstat   ##################################"
/bin/netstat -n | awk '/^tcp/ {++S[$NF]} END {for(a in S) print a, S[a]}'
