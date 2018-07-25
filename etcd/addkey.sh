#!/bin/bash -
print_command() {
    echo "etcd-basics $ $*"
    $*
    read
}

print_explanation() {
    echo "=== $* ==="
}

print_explanation "Add the foo keys and values"
print_command docker exec -it -e ETCDCTL_API=3 etcd0 etcdctl put foo bar
print_command docker exec -it -e ETCDCTL_API=3 etcd0 etcdctl get foo