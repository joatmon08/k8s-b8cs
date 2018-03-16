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

print_explanation "Check out that service!"
print_command kubectl get services

print_explanation "Let's see if we can reach helloworld now!"
print_command curl -v $node_ip:80

print_explanation "Still no. That's because it defaults as an internal service."
read

print_explanation "Let's change our service to be exposed as NodePort."
print_command kubectl apply -f service_nodeport.yaml
print_command kubectl get svc

print_explanation "Let's see if we can reach helloworld now!"
read

node_port=$(kubectl get svc helloworld -o yaml | grep nodePort | cut -d' ' -f6)
print_command curl ${node_ip}:${node_port}

print_explanation "This isn't a great configuration, though. You're exposing your node!"
print_explanation "What happens if the pod changes nodes?"
read

print_explanation "Let's set it back to internal configuration, and see how we can get to it."
print_command "kubectl delete -f service_nodeport.yaml"
print_command kubectl apply -f service.yaml
print_command kubectl get svc

print_explanation "K8s offers its API server as a proxy, so you can test your app."
print_explanation "Let's use the proxy to get to our application."
print_command curl -k https://${node_ip}:8443/api/v1/namespaces/default/services/helloworld:http/proxy

print_explanation "Oh no! I have to authenticate to get to it. This is why we have a token."
print_explanation "Behind the scenes, we're going to grab the service account token."
token=$(kubectl describe secret $(kubectl get secrets | grep default | cut -f1 -d ' ') | grep -E '^token' | cut -f2 -d':' | tr -d '\t' | sed 's/ //g')
read

print_explanation "Let's try it again with the token."
"curl -L -k -X GET https://${node_ip}:8443/api/v1/namespaces/default/services/helloworld:http/proxy -H 'Authorization: Bearer ${token}'"

print_explanation "What happens when I delete the Deployment behind the Service?"
print_command kubectl delete -f deployment.yaml

print_explanation "I'm going to try to reach my app now."
"curl -L -k -X GET https://${node_ip}:8443/api/v1/namespaces/default/services/helloworld:http/proxy -H 'Authorization: Bearer ${token}'"

print_explanation "It's not up! That's because now that I've deleted my deployment, my pods are gone."
print_command kubectl get deployments
print_command kubectl get pods

print_explanation "But my service still exists."
print_command kubectl get services

kubectl delete -f service.yaml > /dev/null
kubectl delete -f deployment.yaml > /dev/null