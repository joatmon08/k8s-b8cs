#!/bin/bash -

print_command() {
    echo "k8s-basics $ $*"
    $*
    read
}

print_explanation() {
    echo "=== $* ==="
}

node_ip=$(minikube ip)

print_explanation "Let's create our Deployment first."
print_command kubectl apply -f deployment.yaml

print_explanation "Now, let's get a Service in front of it."
print_command kubectl apply -f service.yaml

print_explanation "Is the service up?"
token=$(kubectl describe secret $(kubectl get secrets | grep default | cut -f1 -d ' ') | grep -E '^token' | cut -f2 -d':' | tr -d '\t' | sed 's/ //g')
curl -L -k -X GET https://${node_ip}:8443/api/v1/namespaces/default/services/helloworld:http/proxy -H "Authorization: Bearer ${token}"

print_explanation "Recall that when we deleted the Pods, we couldn't reach helloworld anymore."
print_command kubectl delete -f deployment.yaml
curl -L -k -X GET https://${node_ip}:8443/api/v1/namespaces/default/services/helloworld:http/proxy -H "Authorization: Bearer ${token}"

print_explanation "We only had one pod and that means our application has downtime!"
print_explanation "Let's deploy with 3 replicas and see what happens."
print_command kubectl apply -f deployment_scaling.yaml

print_explanation "Do we have three pods?"
print_command kubectl get pods
print_command kubectl get replicasets
print_command kubectl get deployment

print_explanation "Let's hit our application again."
curl -L -k -X GET https://${node_ip}:8443/api/v1/namespaces/default/services/helloworld:http/proxy -H "Authorization: Bearer ${token}"
echo ""
echo ""

print_explanation "Let's kill two pods and check our application."
pods=$(kubectl get pods | grep helloworld | cut -d' ' -f1 | head -n 2)
kubectl delete pods $pods
curl -L -k -X GET https://${node_ip}:8443/api/v1/namespaces/default/services/helloworld:http/proxy -H "Authorization: Bearer ${token}"
echo ""
echo ""

print_explanation "Still up! Let's check out what happened to the pods."
kubectl get pods

kubectl delete -f deployment_scaling.yaml > /dev/null
kubectl delete -f service.yaml > /dev/null