#!/bin/bash
ansible-playbook -i init-cluster/ansible-playbook/hosts init-cluster/ansible-playbook/kube-dependencies.yml
#ansible-playbook -i init-cluster/ansible-playbook/hosts init-cluster/ansible-playbook/master.yml