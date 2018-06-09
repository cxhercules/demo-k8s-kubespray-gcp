pub_key 		= "cust_id_rsa.pub"  	# path for a key to login to jumpbox
api_key 		= "gcp-creds.json"	# GCP credentials file
region 			= "us-central1"
zone 			= "us-central1-a"
project 		= ""
res_prefix 		= ""
subnet_cidr 		= "10.10.0.0/16"
master_group_size	= 3
cluster_zones 	        = [ "us-central1-a", "us-central1-b", "us-central1-c" ]
jumpbox_create          = true
jumpbox_type 		= "n1-standard-1"
jumpbox_image 		= "ubuntu-os-cloud/ubuntu-1604-lts"
master_type 		= "n1-standard-1"
coreos_image            = "coreos-stable-1632-3-0-v20180215"
owner                   = ""
worker_type             = "n1-standard-1"
worker_group_size       = 3
access_config = []
update_strategy = "MIGRATE"
service_account_scopes  = [
  "https://www.googleapis.com/auth/devstorage.read_only",
  "https://www.googleapis.com/auth/logging.write",
  "https://www.googleapis.com/auth/trace.append",
  "https://www.googleapis.com/auth/compute",
  "https://www.googleapis.com/auth/monitoring",
]
