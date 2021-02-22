#!/bin/sh

# Azure CLI 
# Script for creating virtual machines for the k8s cluster in the configuration:
#  --Hardware requirements:
#    - 2x CPU;
#    - 2GB RAM;
#  -- OS requirements:
#      - UbuntuLTS 18.04 
#  -- Architecture:
#     - master server #1: vm-k8s-master-01 [10.0.1.10];
#     - worker server #1: vm-k8s-worker-01 [10.0.1.11];
#     - worker server #2: vm-k8s-worker-02 [10.0.1.12];
#     - admin VM: vm-k8s-admin-server [10.0.1.100];

# vm-k8s-admin-server
# NSG for linux-serer-admin
az network nsg create \
  --resource-group RG-k8s-cluster \
  --name NSG-ADMIN-SERVER

az network nsg rule create \
  --resource-group RG-k8s-cluster \
  --name NSG-ADMIN-SERVER-ALLOW-HTTP \
  --nsg-name NSG-ADMIN-SERVER \
  --protocol tcp \
  --direction inbound \
  --source-address-prefix '*' \
  --source-port-range '*' \
  --destination-address-prefix 'VirtualNetwork' \
  --destination-port-range 80 \
  --access allow \
  --priority 200

az network nsg rule create \
  --resource-group RG-k8s-cluster \
  --name NSG-ADMIN-SERVER-ALLOW-SSH \
  --nsg-name NSG-ADMIN-SERVER \
  --protocol tcp \
  --direction inbound \
  --source-address-prefix '*' \
  --source-port-range '*' \
  --destination-address-prefix 'VirtualNetwork' \
  --destination-port-range 22 \
  --access allow \
  --priority 100

az network public-ip create \
  --resource-group RG-k8s-cluster \
  --name PIP-ADMIN-SERVER \
  --sku Standard \
  --version IPv4

az network nic create \
--resource-group RG-k8s-cluster \
--name admin-server-NIC \
--subnet cluster-SUBNET \
--network-security-group NSG-ADMIN-SERVER \
--private-ip-address 10.0.1.100 \
--public-ip-address PIP-ADMIN-SERVER \
--vnet-name AZ-k8s-vNET

# Deploy admin server
az vm create \
  --resource-group RG-k8s-cluster \
  --name vm-k8s-admin-server \
  --admin-username golubyatnikov \
  --admin-password Upgrade-2035UP \
  --image UbuntuLTS \
  --nics admin-server-NIC \
  --size Standard_B1s \
   
az vm extension set \
  --publisher Microsoft.Azure.Extensions \
  --version 2.0 \
  --name CustomScript \
  --vm-name vm-k8s-admin-server \
  --resource-group RG-k8s-cluster \
  --settings '{"commandToExecute":"apt-get -y update && apt-get -y install nginx && apt-get -y install ansible && echo k8s: admin-server > /var/www/html/index.html" && git clone https://github.com/aleks-golubyatnikov/k8s-cluster.git /home/golubyatnikov/}'