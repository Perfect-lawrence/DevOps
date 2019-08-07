#!/bin/bash
ca_dir=$HOME/.docker
if [ ! -d "${ca_dir}" ]; then
        mkdir -v "${ca_dir}"
fi
if [ -x /usr/bin/openssl ]; then
        echo "###############################################"
        echo "#########  Start Create ca-key.pem ###########"
        echo "###############################################"
        /usr/bin/openssl genrsa -aes256 -out "${ca_dir}"/ca-key.pem 4096
fi
if [ $? -eq 0 ]; then
        echo "#####################################################"
        echo "########  According ca-key.pem Create ca.pem  #######"
        echo "#####################################################"
        /usr/bin/openssl req -new -x509 -days 365 -key "${ca_dir}"/ca-key.pem -sha256 -out "${ca_dir}"/ca.pem
fi
if [ $? -eq 0 ]; then
        echo "######################################################"
        echo "##########  Start Create server-key.pem  #############"
        echo "######################################################"
        /usr/bin/openssl genrsa -out "${ca_dir}"/server-key.pem 4096
fi
if [ $? -eq 0 ]; then
        echo "###############################################################"
        echo "######## According server-key.pem Create server.csr   #########"
        echo "###############################################################"
        HOST=$(hostname)
        echo $HOST
        /usr/bin/openssl req -subj "/CN=$HOST" -new -key "${ca_dir}"/server-key.pem -out "${ca_dir}"/server.csr
fi

