#!/bin/bash -
print_command() {
    echo "etcd-basics $ $*"
    $*
    read
}

print_explanation() {
    echo "=== $* ==="
}

print_explanation "Save snapshot to snapshot.db file"
print_command docker exec -e ETCDCTL_API=3 etcd0 etcdctl --endpoints=127.0.0.1:2379 snapshot save snapshot.db

print_explanation "Check the snapshot"
print_command docker exec -e ETCDCTL_API=3 etcd0 etcdctl --write-out=table snapshot status snapshot.db

print_explanation "Save it from container to local drive"
print_command docker cp etcd0:snapshot.db .