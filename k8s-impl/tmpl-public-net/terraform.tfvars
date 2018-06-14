pub_key = "cust_id_rsa.pub" # path for a key to login to jumpbox
api_key = "gcp-creds.json" # GCP credentials file
region = "us-east4"
zone = "us-east4-a"
project = "myproject" #CHANGEME
res_prefix = "k8s-public" #CHANGEME
subnet_cidr = "10.0.0.0/16"
master_group_size = 3
cluster_zones = ["us-east4-a", "us-east4-b", "us-east4-c"]
jumpbox_create = false
jumpbox_type = "n1-standard-1"
jumpbox_image = "ubuntu-os-cloud/ubuntu-1604-lts"
master_type = "n1-standard-1"
os_image = "coreos-stable-1632-3-0-v20180215"
owner = "thewoman"
worker_type = "n1-standard-1"
worker_group_size = 3
update_strategy = "MIGRATE"

service_account_scopes = [
  "https://www.googleapis.com/auth/devstorage.read_only",
  "https://www.googleapis.com/auth/logging.write",
  "https://www.googleapis.com/auth/trace.append",
  "https://www.googleapis.com/auth/compute",
  "https://www.googleapis.com/auth/monitoring",
]
