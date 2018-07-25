#!/bin/bash -
print_command() {
    echo "etcd-basics $ $*"
    $*
    read
}

print_explanation() {
    echo "=== $* ==="
}

print_explanation "Remove current cluster."
docker rm -f $(docker ps -a -q)

print_explanation "Recover from the backup of store."
print_explanation "Re-create the cluster."
print_command bash create.backend.sh

print_explanation "Did it back it up?"
print_command docker exec -it -e ETCDCTL_API=3 etcd0 etcdctl get foo

print_explanation "Remove current cluster."
docker rm -f $(docker ps -a -q)
rm -rf backup
