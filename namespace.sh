#!/bin/bash -

print_command() {
    echo "k8s-basics $ $*"
    $*
    read
}

print_explanation() {
    echo "=== $* ==="
}

print_explanation "Let's create a qa namespace and a Deployment in qa."
print_explanation "A namespace isolates the cluster's resources."
print_command kubectl create -f namespace.yaml
print_command kubectl get namespace

print_explanation "Let's check our Deployment!"
print_command kubectl get deployment

print_explanation "I don't see it! Where did it go?"
print_explanation "Let's check all namespaces."
print_command kubectl get deployment --all-namespaces

print_explanation "Ok, we see it."
print_explanation "Next time, if I want to be more specific, I can specify which namespace I want."
print_command kubectl get deployment -n qa

kubectl delete -f namespace.yaml > /dev/null