#!/bin/bash

# Prereqs
#ansible
#jinja2
#jinja2-cli
#jq
#terraform

## requirements
# - gcp_creds.json in customer directory
# - terraform.tfvars filled in 

# Variables
git_root=$(git rev-parse --show-toplevel)
cwd=$(pwd)
what_dir=$(basename $(dirname ${cwd}))


# sets default value, but can be overwritten
kubespray_version=${kubespray_versionx:-v2.5.0}

## ensure we are in implementation folder
if [ "${what_dir}" != "k8s-impl" ]; then
   echo "Please run from implementation directory at $git_root/k8s-impl/<implementation_folder>/" 
   exit -1
fi

# customer prefix
export $(grep res_prefix terraform.tfvars |tr -d "[:blank:]")

# Create new rsa keys
if [ ! -f cust_id_rsa ] ; then 
   ssh-keygen -t rsa -b 2048 -f cust_id_rsa -q -N ""
fi

# Load keys
eval $(ssh-agent)
ssh-add -D
ssh-add cust_id_rsa


# Create infrastructure in gcp
terraform init
terraform plan -out cust.plan
terraform apply cust.plan

# gather terraform outputs and gcloud info form master/worker ip addresses
bastion_ip=$(terraform output bastion_ip 2>/dev/null)
lb_ip=$(terraform output lb_ip)
master_ips=$(gcloud compute instances list --filter="${res_prefix}-masters" --format=json |jq -r '.[].networkInterfaces[].networkIP'|tr "\n" " "| sed -e "s/ \{1,\}$//")
node_ips=$(gcloud compute instances list --filter="${res_prefix}-workers" --format=json |jq -r '.[].networkInterfaces[].networkIP'|tr "\n" " "| sed -e "s/ \{1,\}$//")

# Clone kubespray repo and checkout particular tag
git clone https://github.com/kubernetes-incubator/kubespray.git
cd kubespray && git checkout ${kubespray_version}

# bring in modifications, in particular security changes
rsync -avz $git_root/mods/roles/* roles/

### we need to use template for inventory
echo "bastion: $bastion_ip"
echo "lb: $lb_ip"
echo "masters: $master_ips"
echo "workers: $node_ips"

## jinja2 template generation of inventory
# check if directory for group vars exist
if [ ! -d inventory/group_vars ]; then
  mkdir -p inventory/group_vars
fi 

jq -n --arg masters "$master_ips" --arg nodes "$node_ips" --arg bastion_ip "$bastion_ip" '{ "masters":  ($masters|split(" ")), "nodes":  ($nodes|split(" ")), "bastion_ip": $bastion_ip  }'|jinja2 $git_root/templates/hosts.ini.jinja2 > inventory/hosts.ini
jq -n --arg lb_ip "$lb_ip" '{ "lb_ip": $lb_ip  }'|jinja2 $git_root/templates/group_vars/all.yml.jinja2 > inventory/group_vars/all.yml
jq -n --arg lb_ip "$lb_ip" '{ "lb_ip": $lb_ip  }'|jinja2 $git_root/templates/group_vars/k8s-cluster.yml.jinja2 > inventory/group_vars/k8s-cluster.yml

ansible-playbook -vvv -i inventory/hosts.ini cluster.yml --flush-cache

#change the admin.conf file to the current lb_ip
sed -i -e "s/lb-apiserver.kubernetes.local/$lb_ip/g" artifacts/admin.conf
