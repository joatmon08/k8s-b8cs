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
* You have a Kubernetes cluster. Feel free to set it up locally.

## The Pod
Let's deploy an application in a simple pod. 

Run `pod.sh` to begin the example.

## The Deployment
Well, one pod was killed pretty easily. We want to make sure
our application is always up! Let's try to use a deployment
so our pods will get rescheduled if they die. 

Run `deployment.sh` to begin the example.