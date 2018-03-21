# Kubernetes: The Basics

Let's deploy an application to Kubernetes, construct by construct. Remember:

* A Pod contains everything my app needs.
* A Deployment describes how many pods I want.
* A Service lets my app be discoverable.
* A Namespace isolates my app’s resources.

In this reference tutorial, we're going to deploy an application called
`helloworld` that uses the container image `nginx`. nginx is simple web
server and demonstrates each type of Kubernetes construct and
its relevance.

## Pre-Requisites
* You have a [Minikube](https://github.com/kubernetes/minikube) Kubernetes cluster.

## The Pod
Let's deploy an application in a simple pod. 

Run `pod.sh` to begin the example.

## The Deployment
Well, one pod was killed pretty easily. We want to make sure
our application is always up! Let's try to use a deployment
so our pods will get rescheduled if they die. 

Run `deployment.sh` to begin the example.

## The Service
We can't access our application with just a deployment,
there's nothing set up for us to access it. Let's see
what it takes to expose our service to the world.

Run `service.sh` to begin the example.

## Scaling
One pod, when it dies, means our application has downtime.
What can we do to ensure we've got high availability?
We can specify the replicas we want.

Run `scaling.sh` to begin the example.

## Namespace
Use namespaces to isolate cluster resources. Here, we'll spin up
a namespace and a deployment in that namespace.

Run `namespace.sh` to begin the example.

## Secrets
Secrets can be inserted as part of the pod. Here's how
you would create a secret, and use it as part of the 
application.

Run `secrets.sh` to begin the example.