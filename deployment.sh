#!/bin/bash -

print_command() {
    echo "k8s-basics $ $*"
    $*
    read
}

print_explanation() {
    echo "=== $* ==="
}

print_explanation "Let's create the deployment from the manifest."
print_command kubectl create -f deployment.yaml

print_explanation "Get the list of Deployments."
print_command kubectl get deployments

print_explanation "Let's check out the ReplicaSets that have come from the Deployment."
print_command kubectl get replicasets

print_explanation "Let's check out the Pods that have come from the ReplicaSet."
print_command kubectl get pods

pod=$(kubectl get pods | grep helloworld | cut -d' ' -f1)

print_explanation "Let's kill a pod and see what happens now."
print_command kubectl delete pod ${pod}

print_explanation "Let's check out the ReplicaSets now that we've killed one."
print_command kubectl get replicasets

print_explanation "What about the Deployments?"
print_command kubectl get deployments

print_explanation "Is the pod the same as before?"
print_command kubectl get pods

print_explanation "Let's see if we can reach helloworld!"
print_command curl -v $(minikube ip):80
echo ""
echo ""

kubectl delete -f deployment.yaml > /dev/null