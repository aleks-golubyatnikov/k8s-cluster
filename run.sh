#!/bin/bash
ansible-playbook -i ./ansible-playbook/hosts ./ansible-playbook/kube-dependencies.yml >> instalation.log
ansible-playbook -i ./ansible-playbook/hosts ./ansible-playbook/master.yml >> configure-master.log
kubectl get nodes >> nodes.log