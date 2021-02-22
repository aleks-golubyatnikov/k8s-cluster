!#/bin/sh
cd /home/golubyatnikov/k8s-cluster/ansible-playbook
ansible-playbook -i hosts kube-dependencies.yml -k
ansible-playbook -i hosts master.yml -k
