#!/usr/bin/env bash
set -e
OUTPUT_FILE=/vagrant/kubeadm.log
rm -rf $OUTPUT_FILE
sudo kubeadm init --apiserver-advertise-address=10.0.0.10 --pod-network-cidr=10.244.0.0/16 --ignore-preflight-errors=NumCPU --ignore-preflight-errors=Mem | tee ${OUTPUT_FILE}
chmod +x $OUTPUT_FILE
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml

mkdir -p /home/vagrant/.kube
sudo cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config
sudo chown -R  vagrant: /home/vagrant/.kube/

