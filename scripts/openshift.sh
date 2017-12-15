#!/usr/bin/env bash

yum install -y git centos-release-openshift-origin
yum update -y
yum install -y yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install -y docker-ce
usermod -aG docker vagrant
systemctl is-active docker
systemctl enable docker
systemctl start docker
echo '{"insecure-registries" : ["172.30.0.0/16"]}' > /etc/docker/daemon.json
systemctl restart docker

yum install -y origin-clients 
git clone https://github.com/openshift-evangelists/oc-cluster-wrapper
chown -R vagrant:docker oc-cluster-wrapper
oc-cluster-wrapper/oc-cluster up --public-hostname=`hostname -i`