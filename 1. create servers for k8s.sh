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

az group create \
--name RG-k8s-cluster \
--location centralus

az network vnet create \
--resource-group RG-k8s-cluster \
--name AZ-k8s-vNET \
--address-prefix 10.0.0.0/16 \
--subnet-name k8s-SUBNET \
--subnet-prefix 10.0.0.0/24

az network vnet subnet create \
--address-prefixes 10.0.1.0/24 \
--name cluster-SUBNET \
--vnet-name AZ-k8s-vNET \
--resource-group RG-k8s-cluster

# vm-k8s-master-01
# NSG for master server #1
az network nsg create \
  --resource-group RG-k8s-cluster \
  --name NSG-MASTER-SERVER-01

az network nsg rule create \
  --resource-group RG-k8s-cluster \
  --name NSG-MASTER-SERVER-01-ALLOW-HTTP \
  --nsg-name NSG-MASTER-SERVER-01 \
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
  --name NSG-MASTER-SERVER-01-ALLOW-SSH \
  --nsg-name NSG-MASTER-SERVER-01\
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
  --name PIP-MASTER-01 \
  --sku Standard \
  --version IPv4

az network nic create \
--resource-group RG-k8s-cluster \
--name master-01-NIC \
--subnet cluster-SUBNET \
--network-security-group NSG-MASTER-SERVER-01 \
--private-ip-address 10.0.1.10 \
--public-ip-address PIP-MASTER-01 \
--vnet-name AZ-k8s-vNET

# Deploy master server #1
az vm create \
  --resource-group RG-k8s-cluster \
  --name vm-k8s-master-01 \
  --admin-username golubyatnikov \
  --admin-password Upgrade-2035UP \
  --image UbuntuLTS \
  --nics master-01-NIC \
  --size Standard_B1s  
   
az vm extension set \
  --publisher Microsoft.Azure.Extensions \
  --version 2.0 \
  --name CustomScript \
  --vm-name vm-k8s-master-01 \
  --resource-group RG-k8s-cluster \
  --settings '{"commandToExecute":"apt-get -y update && apt-get -y install nginx && echo k8s: vm-k8s-master-01 > /var/www/html/index.html"}'


# vm-k8s-worker-01
# NSG for worker server #1
az network nsg create \
  --resource-group RG-k8s-cluster \
  --name NSG-WORKER-SERVER-01

az network nsg rule create \
  --resource-group RG-k8s-cluster \
  --name NSG-WORKER-SERVER-01-ALLOW-HTTP \
  --nsg-name NSG-WORKER-SERVER-01 \
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
  --name NSG-WORKER-SERVER-01-ALLOW-SSH \
  --nsg-name NSG-WORKER-SERVER-01\
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
  --name PIP-WORKER-01 \
  --sku Standard \
  --version IPv4

az network nic create \
--resource-group RG-k8s-cluster \
--name worker-01-NIC \
--subnet cluster-SUBNET \
--network-security-group NSG-MASTER-SERVER-01 \
--private-ip-address 10.0.1.11 \
--public-ip-address PIP-WORKER-01 \
--vnet-name AZ-k8s-vNET

# Deploy worker server #1
az vm create \
  --resource-group RG-k8s-cluster \
  --name vm-k8s-worker-01 \
  --admin-username golubyatnikov \
  --admin-password Upgrade-2035UP \
  --image UbuntuLTS \
  --nics worker-01-NIC \
  --size Standard_B1s \
   
az vm extension set \
  --publisher Microsoft.Azure.Extensions \
  --version 2.0 \
  --name CustomScript \
  --vm-name vm-k8s-worker-01 \
  --resource-group RG-k8s-cluster \
  --settings '{"commandToExecute":"apt-get -y update && apt-get -y install nginx && echo k8s: vm-k8s-worker-01 > /var/www/html/index.html"}'


# vm-k8s-worker-02
# NSG for worker server #2
az network nsg create \
  --resource-group RG-k8s-cluster \
  --name NSG-WORKER-SERVER-02

az network nsg rule create \
  --resource-group RG-k8s-cluster \
  --name NSG-WORKER-SERVER-02-ALLOW-HTTP \
  --nsg-name NSG-WORKER-SERVER-02 \
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
  --name NSG-WORKER-SERVER-02-ALLOW-SSH \
  --nsg-name NSG-WORKER-SERVER-02\
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
  --name PIP-WORKER-02 \
  --sku Standard \
  --version IPv4

az network nic create \
--resource-group RG-k8s-cluster \
--name worker-02-NIC \
--subnet cluster-SUBNET \
--network-security-group NSG-MASTER-SERVER-01 \
--private-ip-address 10.0.1.12 \
--public-ip-address PIP-WORKER-02 \
--vnet-name AZ-k8s-vNET

# Deploy worker server #2
az vm create \
  --resource-group RG-k8s-cluster \
  --name vm-k8s-worker-02 \
  --admin-username golubyatnikov \
  --admin-password Upgrade-2035UP \
  --image UbuntuLTS \
  --nics worker-02-NIC \
  --size Standard_B1s \
   
az vm extension set \
  --publisher Microsoft.Azure.Extensions \
  --version 2.0 \
  --name CustomScript \
  --vm-name vm-k8s-worker-02 \
  --resource-group RG-k8s-cluster \
  --settings '{"commandToExecute":"apt-get -y update && apt-get -y install nginx && echo k8s: vm-k8s-worker-02 > /var/www/html/index.html"}'