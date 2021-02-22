!#/bin/sh

# HOWTO: https://www.digitalocean.com/community/tutorials/how-to-create-a-kubernetes-cluster-using-kubeadm-on-ubuntu-18-04-ru
#
# 1: Install packages to all hosts
#
# cd /home/golubyatnikov/ansible-playbook
# ansible-playbook -i hosts kube-dependencies.yml -k
#
# 2: Configure the master host
# ansible-playbook -i hosts master.yml -k

