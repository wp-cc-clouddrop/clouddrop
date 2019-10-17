# README

This directory contains configuration files to deploy services to Kubernetes.

- `files-deployment.yaml`: files service configuration
- `users-deployment.yaml`: user service configuration
- `nginx-ingress.yaml`: NGINX resource configuration. Tested only on minikube
- `kubelogin`: script to setup access to haw-icc Kubernetes cluster

## Steps to deploy

### Minikube

1. Enable default NGINX IngressController: `minikube addons enable ingress`
2. Deploy files service: `kubectl apply -f files-deployment.yaml`
3. Deploy user service: `kubectl apply -f users-deployment.yaml`
4. Deploy NGINX Ingress resource: `kubectl apply -f nginx-ingress.yaml`
5. Add `$(minikube ip) clouddrop.xyz` to `/etc/hosts`
6. Test access using Postman/Browser

### haw-icc

TODO