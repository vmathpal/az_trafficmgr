#!/bin/bash
#az login --service-principal --username a834aa0a-698a-4c05-be00-2c910790da62 --password 4QRZxIKA_X7R29mQ_sQ_vhIn~q9~-1GkYX --tenant 66e853de-ece3-44dd-9d66-ee6bdf4159d4
group=vibhor
username=adminuser
password='Covid@192021'

az group create -g $group -l northeurope

az vm create \
  -n vm-northeurope \
  -g $group \
  -l northeurope \
  --image Win2019Datacenter \
  --admin-username $username \
  --admin-password $password \
  --nsg-rule rdp
  
az vm create \
  -n vm-eastus2 \
  -g $group \
  -l eastus2 \
  --image Win2019Datacenter \
  --admin-username $username \
  --admin-password $password \
  --nsg-rule rdp

az appservice plan create \
  -n web-eastus2-plan \
  -g $group \
  -l eastus2 \
  --sku S1
  
#appname=demo-web-eastus2-$RANDOM$RANDOM
#az webapp create \
 # -n $appname \ 
  -g $group \
  -p web-eastus2-plan
  
az appservice plan create \
  -n web-northeurope-plan \
  -g $group \
  -l northeurope \
  --sku S1
  
appname=demo-web-northeurope-$RANDOM$RANDOM
az webapp create \
  -n $appname \
  -g $group \
  -p web-northeurope-plan
  
az webapp list -g $group --query "[].enabledHostNames" -o jsonc

az vm list \
  -g $group -d \
  --query "[].{name:name,ip:publicIps,user:osProfile.adminUsername,password:'$password'}" \
  -o jsonc
