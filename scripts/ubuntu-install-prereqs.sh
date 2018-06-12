#!/bin/bash
sudo apt-get update
sudo apt-get install unzip jq python-pip python-netaddr -y
sudo pip install ansible
sudo pip install jinja2
sudo pip install jinja2-cli


###
## check if terraform is running on machine
###
TERRACHECK=$(terraform -h 2>/dev/null | grep Usage)
if [[ -z $TERRACHECK ]]; then
    echo "installing terraform"
    wget https://releases.hashicorp.com/terraform/0.11.7/terraform_0.11.7_linux_amd64.zip
    unzip terraform_0.11.7_linux_amd64.zip && rm terraform_0.11.7_linux_amd64.zip 
    chmod +x terraform
    sudo mv terraform /usr/local/bin/terraform
    terraform -h | grep Usage 2>&1 1>/dev/null || exit 1
    echo "terraform installed successfully"
fi

