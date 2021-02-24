#!/bin/bash
ansible-playbook -i ./ansible-playbook/hosts ./ansible-playbook/initial.yml >> initial.log
ansible-playbook -i ./ansible-playbook/hosts ./ansible-playbook/kube-dependencies.yml >> instalation.log
ansible-playbook -i ./ansible-playbook/hosts ./ansible-playbook/master.yml >> configure-master.log

#ansible-playbook -i ./ansible-playbook/hosts ./ansible-playbook/workers.yml >> configure-workers.log
#ansible-playbook -i ./ansible-playbook/hosts ./ansible-playbook/k8s-cluster.yml >> configure-k8s-cluster.log
