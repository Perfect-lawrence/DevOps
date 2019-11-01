# shell中数组的定义及遍历

#### 定义数组方法一 
```bash

KUBECTL_PRUNE_WHITELIST=(
  core/v1/ConfigMap
  core/v1/Endpoints
  core/v1/Namespace
  core/v1/PersistentVolumeClaim
  core/v1/PersistentVolume
  core/v1/Pod
  core/v1/ReplicationController
  core/v1/Secret
  core/v1/Service
  batch/v1/Job
  batch/v1beta1/CronJob
  apps/v1/DaemonSet
  apps/v1/Deployment
  apps/v1/ReplicaSet
  apps/v1/StatefulSet
  extensions/v1beta1/Ingress
)
```

#### 定义数组方法二

```bash
KUBECTL_API_RESOURCE[0]="cs"
KUBECTL_API_RESOURCE[1]="svc"
KUBECTL_API_RESOURCE[2]="cm"
KUBECTL_API_RESOURCE[3]="ep"
KUBECTL_API_RESOURCE[4]="ns"
KUBECTL_API_RESOURCE[5]="pvc"
KUBECTL_API_RESOURCE[6]="pv"
KUBECTL_API_RESOURCE[7]="po"
KUBECTL_API_RESOURCE[8]="rc"
```
#### 获取数组的长度

```bash
[xiangxh@server01 ~]$ echo ${#KUBECTL_PRUNE_WHITELIST[@]}
16
[xiangxh@server01 ~]$ echo ${#KUBECTL_API_RESOURCE[@]}
9

```bash

#### for 遍历数组

```bash
for i in ${KUBECTL_PRUNE_WHITELIST[@]}
do
	echo "${i}"
done

for y in ${KUBECTL_API_RESOURCE[@]}
do
	echo ${y}
done
```

#### while 遍历数组

```bash
w=0

while [[ w -lt ${#KUBECTL_API_RESOURCE[@]} ]]; do
	echo ${KUBECTL_API_RESOURCE[w]}
	let w++
done

while [[ w -lt ${#KUBECTL_API_RESOURCE[@]} ]]; do
	echo ${KUBECTL_API_RESOURCE[w]}
	let w++
done
```
