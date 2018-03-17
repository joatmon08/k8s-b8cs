#!/bin/bash -

print_command() {
    echo "k8s-basics $ $*"
    $*
    read
}

print_explanation() {
    echo "=== $* ==="
}

print_explanation "Let's create a secret by passing it in literally."
print_explanation "There are other options, but here is one way."
print_command kubectl create secret generic helloworld --from-literal=MY_ENV_VARIABLE='SECRETS!'

print_explanation "Check the secret's been created."
print_command kubectl get secret helloworld
print_command kubectl describe secret helloworld

print_explanation "Let's create a deployment that requires a secret."
print_command kubectl create -f deployment_secret.yaml

print_explanation "Now that we've got a deployment, let's check if the secret is in the pod."
pod=$(kubectl get pods | grep helloworld | cut -d' ' -f1)
print_command kubectl exec $pod env

kubectl delete -f deployment_secret.yaml > /dev/null
kubectl delete secret helloworld > /dev/null