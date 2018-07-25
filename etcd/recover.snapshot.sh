#!/bin/bash -
print_command() {
    echo "etcd-basics $ $*"
    $*
    read
}

print_explanation() {
    echo "=== $* ==="
}

REGISTRY=quay.io/coreos/etcd
# For each machine
ETCD_VERSION=latest
TOKEN=my-etcd-token
CLUSTER_STATE=new
NAME_1=etcd0
NAME_2=etcd1
NAME_3=etcd2
HOST_1=172.17.0.2
HOST_2=172.17.0.3
HOST_3=172.17.0.4
CLUSTER=${NAME_1}=http://${HOST_1}:2380,${NAME_2}=http://${HOST_2}:2380,${NAME_3}=http://${HOST_3}:2380
DATA_DIR=/var/lib/etcd

print_explanation "Remove current cluster."
docker rm -f $(docker ps -a -q)

THIS_NAME=${NAME_1}
THIS_IP=${HOST_1}
print_explanation "Run first seed node container without anything."
print_command docker run -d \
  --name ${THIS_NAME} ${REGISTRY}:${ETCD_VERSION} \
  sleep 900

print_explanation "Copy the snapshot file into the container."
print_command docker cp snapshot.db ${THIS_NAME}:snapshot.db

print_explanation "Restore from the snapshot file."
print_command docker exec -e ETCDCTL_API=3 ${THIS_NAME} \
  /usr/local/bin/etcdctl snapshot restore snapshot.db \
  --data-dir=/etcd-data --name ${THIS_NAME} \
  --initial-advertise-peer-urls http://${THIS_IP}:2380 \
  --initial-cluster ${CLUSTER} --initial-cluster-token ${TOKEN}

print_explanation "Restart the cluster."
print_command docker exec -d -e ETCDCTL_API=3 ${THIS_NAME} \
  etcd --data-dir=/etcd-data --name ${THIS_NAME} \
  --initial-advertise-peer-urls http://${THIS_IP}:2380 --listen-peer-urls http://0.0.0.0:2380 \
  --advertise-client-urls http://${THIS_IP}:2379 --listen-client-urls http://0.0.0.0:2379 \
  --initial-cluster ${CLUSTER} --initial-cluster-token ${TOKEN}

THIS_NAME=${NAME_2}
THIS_IP=${HOST_2}
print_explanation "Run second seed node container without anything."
print_command docker run -d \
  --name ${THIS_NAME} ${REGISTRY}:${ETCD_VERSION} \
  sleep 900

print_explanation "Copy the snapshot file into the container."
print_command docker cp snapshot.db ${THIS_NAME}:snapshot.db

print_explanation "Restore from the snapshot file."
print_command docker exec -e ETCDCTL_API=3 ${THIS_NAME} \
  /usr/local/bin/etcdctl snapshot restore snapshot.db \
  --data-dir=/etcd-data --name ${THIS_NAME} \
  --initial-advertise-peer-urls http://${THIS_IP}:2380 \
  --initial-cluster ${CLUSTER} \
  --initial-cluster-token ${TOKEN}

print_explanation "Restart the cluster."
print_command docker exec -d -e ETCDCTL_API=3 ${THIS_NAME} \
  etcd --data-dir=/etcd-data --name ${THIS_NAME} \
  --initial-advertise-peer-urls http://${THIS_IP}:2380 --listen-peer-urls http://0.0.0.0:2380 \
  --advertise-client-urls http://${THIS_IP}:2379 --listen-client-urls http://0.0.0.0:2379 \
  --initial-cluster ${CLUSTER} --initial-cluster-token ${TOKEN}

THIS_NAME=${NAME_3}
THIS_IP=${HOST_3}
print_explanation "Run third seed node container without anything."
print_command docker run -d \
  --name ${THIS_NAME} ${REGISTRY}:${ETCD_VERSION} \
  sleep 900

print_explanation "Copy the snapshot file into the container."
print_command docker cp snapshot.db ${THIS_NAME}:snapshot.db

print_explanation "Restore from the snapshot file."
print_command docker exec -e ETCDCTL_API=3 ${THIS_NAME} \
  /usr/local/bin/etcdctl snapshot restore snapshot.db \
  --data-dir=/etcd-data --name ${THIS_NAME} \
  --initial-advertise-peer-urls http://${THIS_IP}:2380 \
  --initial-cluster ${CLUSTER} \
  --initial-cluster-token ${TOKEN}

print_explanation "Restart the cluster."
print_command docker exec -d -e ETCDCTL_API=3 ${THIS_NAME} \
  etcd --data-dir=/etcd-data --name ${THIS_NAME} \
  --initial-advertise-peer-urls http://${THIS_IP}:2380 --listen-peer-urls http://0.0.0.0:2380 \
  --advertise-client-urls http://${THIS_IP}:2379 --listen-client-urls http://0.0.0.0:2379 \
  --initial-cluster ${CLUSTER} --initial-cluster-token ${TOKEN}

print_explanation "Did it back it up?"
print_command docker exec -it -e ETCDCTL_API=3 etcd0 etcdctl get foo

print_explanation "Remove current cluster."
docker rm -f $(docker ps -a -q)
rm -rf snapshot.db