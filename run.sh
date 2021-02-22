!#/bin/sh
cd /home/init-cluster/k8s-cluster/ansible-playbook
ansible-playbook -i hosts kube-dependencies.yml -k
ansible-playbook -i hosts master.yml -k
