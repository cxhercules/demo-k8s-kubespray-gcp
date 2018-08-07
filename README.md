# demo-k8s-kubespray-gcp
Demo code for deployment of Kubespray to GCP

## Getting Started

The following below will guide you to getting started.
### Prerequisites

What things you need to install the software and how to install them
* git
* A service account json key from gcp with Compute Admin privilages, this will also be used to configure gcloud sdk
* terraform
* pip
* ansible
* Jinja2
* python-netaddr
* kubectl
* gcloud


### Prerequisites can be installed on default debian 9.5 or ubuntu 16.04 by running included script. You will need to have sudo on system:
```
sudo apt-get update && sudo apt-get install git -y
git clone https://github.com/cxhercules/demo-k8s-kubespray-gcp.git
cd demo-k8s-kubespray-gcp/
./scripts/ubuntu-install-prereqs.sh
```

### Installing
Create a new k8s deployment.

```
git clone https://github.com/cxhercules/demo-k8s-kubespray-gcp.git
cd demo-k8s-kubespray-gcp/k8s-impl/
cp -a impl-template <myproject>
cd <myproject>
vim terraform.tfvars
```

### Modify terraform.tfvars to fit your needs and we can go ahead with next step.
```
pub_key 		= "cust_id_rsa.pub"  	# path for a key to login to jumpbox, and other systems
api_key 		= "gcp-creds.json"	# GCP credentials file
region 			= "us-west1"
zone 			  = "us-west1-a"
project 		= "myproject"
res_prefix 	= "demo-k8s"
owner       = "cxh"
```

### Kickoff deployment with wrapper script
```
pwd
.../demo-k8s-kubespray-gcp/k8s-impl/<myproject>
./kubespray.sh
```
* While working out some issues ./kubespray.sh can be run multiple times. 

Tear down k8s environment

```
cxh@jmp:~/demo-k8s-kubespray-gcp/k8s-impl/cxh-demo$ terraform destroy
random_id.rand: Refreshing state... (ID: HORoM6ngMUM)
data.template_file.nat-startup-script: Refreshing state...
google_compute_health_check.default: Refreshing state... (ID: demo-k8s-hc)
google_compute_health_check.mig-health-check: Refreshing state... (ID: demo-k8s-nat-gateway-us-west1-b)
...
...
  Plan: 0 to add, 0 to change, 30 to destroy.

  Do you really want to destroy?
    Terraform will destroy all your managed infrastructure, as shown above.
    There is no undo. Only 'yes' will be accepted to confirm.

    Enter a value: yes
```

## Troubleshooting

#Connection issues

At times I have run into cannot connect to master issues or other systems. If it is first run, it just might be intermittent. Still investigating if timing issue. I have just run once more, and problem has been resolved. 

GCP SDK Setup
```
gcloud auth activate-service-account --key-file gcp-creds.json
Activated service account credentials for: [<service-account-name>@<project>.iam.gserviceaccount.com]
```

If you don't run above you may see this error when running kubespray.sh script:
```
ERROR: (gcloud.compute.instances.list) Some requests did not succeed:
 - Insufficient Permission
```

## Authors

* **Christian Hercules** - *Initial work* - [github](https://github.com/cxhercules)

