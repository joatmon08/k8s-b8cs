#!/bin/bash -

print_command() {
    echo "k8s-basics $ $*"
    $*
    read
}

print_explanation() {
    echo "=== $* ==="
}

print_explanation "Let's create a pod."
print_command kubectl create -f pod.yaml

print_explanation "Is it up?"
print_command kubectl get pods

print_explanation "Let's check if it got my pod spec."
print_command kubectl get pods helloworld -o yaml

print_explanation "Did my environment variable get set?"
print_command kubectl exec helloworld env

print_explanation "What happens when I delete the pod?"
print_command kubectl delete pod helloworld

print_explanation "It's gone and it's not coming back!"
print_command kubectl get pods

kubectl delete -f pod.yaml > /dev/null