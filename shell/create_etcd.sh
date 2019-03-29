#!/usr/bin/env bash
# 创建etcd证书

function etcd_deploy {
if [ ! -d /kubernetes ]; then
	mkdir -pv /kubernetes/{bin,ssl,cfg}
elif [ ! -d /data/etcd ]; then
	mkdir /data/etcd
elif 
fi
etcd_version=v3.3.12
cd /kubernetes/ssl/etcd_ssl
# etcd ca配置
cat << EOF | tee etcd_ca-config.json
{
  "signing": {
    "default": {
      "expiry": "87600h"
    },
    "profiles": {
      "etcd": {
         "expiry": "87600h",
         "usages": [
            "signing",
            "key encipherment",
            "server auth",
            "client auth"
        ]
      }
    }
  }
}
EOF

# etcd ca证书
cat << EOF | tee etcd_ca-csr.json
{
    "CN": "etcd CA",
    "key": {
        "algo": "rsa",
        "size": 2048
    },
    "names": [
        {
            "C": "CN",
            "L": "Shenzhen",
            "ST": "Shenzhen"
        }
    ]
}
EOF

# etcd server证书

cat << EOF | tee etcd_server-csr.json
{
    "CN": "etcd",
    "hosts": [
    "192.168.203.11",
    "192.168.203.12",
    "192.168.203.13"
    ],
    "key": {
        "algo": "rsa",
        "size": 2048
    },
    "names": [
        {
            "C": "CN",
            "L": "Shenzhen",
            "ST": "Shenzhen"
        }
    ]
}
EOF

# 生成etcd ca证书和私钥 初始化ca
/usr/local/bin/cfssl gencert -initca etcd_ca-csr.json | /usr/local/bin/cfssljson -bare etcd_ca 

# 生成server证书

/usr/local/bin/cfssl gencert -ca=etcd_ca.pem -ca-key=etcd_ca-key.pem -config=etcd_ca-config.json -profile=etcd etcd_server-csr.json | /usr/local/bin/cfssljson -bare etcd_server

# etcd安装
etcd_version=v3.3.12
cd /home/lawrence/k8s/
tar -xf etcd-"${etcd_version}"-linux-amd64.tar.gz && cp -v etcd-"${etcd_version}"-linux-amd64/{etcd,etcdctl} /kubernetes/bin/

# 配置etcd主文件
cat <<EOF | tee /kubernetes/cfg/etcd.conf
#[Member]
ETCD_NAME="etcd01"
ETCD_DATA_DIR="/data/etcd"
ETCD_LISTEN_PEER_URLS="https://192.168.203.11:2380"
ETCD_LISTEN_CLIENT_URLS="https://192.168.203.11:2379"
 
#[Clustering]
ETCD_INITIAL_ADVERTISE_PEER_URLS="https://192.168.203.11:2380"
ETCD_ADVERTISE_CLIENT_URLS="https://192.168.203.11:2379"
ETCD_INITIAL_CLUSTER="etcd01=https://192.168.203.11:2380,etcd02=https://192.168.203.12:2380,etcd03=https://192.168.203.13:2380"
ETCD_INITIAL_CLUSTER_TOKEN="etcd-cluster"
ETCD_INITIAL_CLUSTER_STATE="new"

#[Security]
ETCD_CERT_FILE="/kubernetes/ssl/etcd_ssl/etcd_server.pem"
ETCD_KEY_FILE="/kubernetes/ssl/etcd_ssl/etcd_server-key.pem"
ETCD_TRUSTED_CA_FILE="/kubernetes/ssl/etcd_ssl/etcd_ca.pem"
ETCD_CLIENT_CERT_AUTH="true"
ETCD_PEER_CERT_FILE="/kubernetes/ssl/etcd_ssl/etcd_server.pem"
ETCD_PEER_KEY_FILE="/kubernetes/ssl/etcd_ssl/etcd_server-key.pem"
ETCD_PEER_TRUSTED_CA_FILE="/kubernetes/ssl/etcd_ssl/etcd_ca.pem"
ETCD_PEER_CLIENT_CERT_AUTH="true"

EOF
}

# 配置etcd启动文件
cat <<EOF | tee /usr/lib/systemd/system/etcd.service
[Unit]
Description=Etcd Server
After=network.target
After=network-online.target
Wants=network-online.target

[Service]
Type=notify
WorkingDirectory=/data/etcd/
EnvironmentFile=-/kubernetes/cfg/etcd.conf
# set GOMAXPROCS to number of processors
ExecStart=/bin/bash -c "GOMAXPROCS=$(nproc) /kubernetes/bin/etcd --name=\"${ETCD_NAME}\" --data-dir=\"${ETCD_DATA_DIR}\" --listen-client-urls=\"${ETCD_LISTEN_CLIENT_URLS}\" --listen-peer-urls=\"${ETCD_LISTEN_PEER_URLS}\" --advertise-client-urls=\"${ETCD_ADVERTISE_CLIENT_URLS}\" --initial-cluster-token=\"${ETCD_INITIAL_CLUSTER_TOKEN}\" --initial-cluster=\"${ETCD_INITIAL_CLUSTER}\" --initial-cluster-state=\"${ETCD_INITIAL_CLUSTER_STATE}\" --cert-file=\"${ETCD_CERT_FILE}\" --key-file=\"${ETCD_KEY_FILE}\" --trusted-ca-file=\"${ETCD_TRUSTED_CA_FILE}\" --client-cert-auth=\"${ETCD_CLIENT_CERT_AUTH}\" --peer-cert-file=\"${ETCD_PEER_CERT_FILE}\" --peer-key-file=\"${ETCD_PEER_KEY_FILE}\" --peer-trusted-ca-file=\"${ETCD_PEER_TRUSTED_CA_FILE}\" --peer-client-cert-auth=\"${ETCD_PEER_CLIENT_CERT_AUTH}\""
Restart=on-failure
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF
