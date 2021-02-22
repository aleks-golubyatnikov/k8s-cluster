!#/bin/sh
cd /home/init-cluster/k8s-cluster/ansible-playbook
ansible-playbook -i hosts kube-dependencies.yml
ansible-playbook -i hosts master.yml
