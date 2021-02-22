#!/bin/bash
ansible-playbook -i ./ansible-playbook/hosts ./ansible-playbook/kube-dependencies.yml >> instalation.log
#ansible-playbook -i init-cluster/ansible-playbook/hosts init-cluster/ansible-playbook/master.yml