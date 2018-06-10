# demo-k8s-kubespray-gcp
Demo code for deployment of Kubespray to GCP

## Getting Started

The following below will guide you to getting started.
### Prerequisites

What things you need to install the software and how to install them
* git
* A service account json key from gcp.
* terraform
* ansible


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


## Authors

* **Christian Hercules** - *Initial work* - [github](https://github.com/cxhercules)

