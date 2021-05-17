# VSFTPD for Kubernetes

## Description

This is an attempt to run VSFTPD in Kubernetes. 
Inspired by [https://github.com/fauria/docker-vsftpd]

## Known issues
* FTP is very old protocol, so it's very insecure
* Due to vsftpd limitations, for proper running it uses host network instead of K8s node ports
* Quite complicated user management

## How to try
It's possible to run it in regular Kubernetes, but for testing purposes it's better to use Minikube.

1. Install (Minikube)[https://minikube.sigs.k8s.io/docs/start/] and set up a cluster
2. Install (kubectl)[https://kubernetes.io/docs/tasks/tools/] and (Helm)[https://helm.sh/docs/intro/install/]
3. Install some addons for Minikube:
```bash
minikube addons enable dashboard
minikube addons enable metrics-server
minikube addons enable ingress
```
4. Check whether kubectl can connect to the cluster or not: 
```bash
kubectl get nodes
```
5. Clone this repo
6. Install this Helm chart to the cluster:
```bash
helm install my-ftp ./vsftpd --set vsftpd.user.name=${FTP_USER} --set vsftpd.user.name=${FTP_PASS} --set ingress.hostname=${DOMAIN}
```
7. Get IP address of your cluster:
```bash
minikube ip
```
8. Add to `/etc/hosts` an entry for checking ingress for http
```
${MINIKUBE_IP}   ${DOMAIN}
```
9. Try to connect to the server by using FTP and HTTP clients