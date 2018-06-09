provider "google" {
  credentials = "${file("${var.api_key}")}"
  project     = "${var.project}"
  region      = "${var.region}"
  version     = "~> 1.8"
}

provider "template" {
  version = "~> 1.0"
}

provider "null" {
  version = "~> 1.0"
}

module "network" {
  source = "../../tf-modules/gce-network"

  region      = "${var.region}"
  res_prefix  = "${var.res_prefix}"
  subnet_cidr = "${var.subnet_cidr}"
}

module "nat-gateway" {
  source = "github.com/GoogleCloudPlatform/terraform-google-nat-gateway"

  name       = "${var.res_prefix}-"
  region     = "${var.region}"
  network    = "${module.network.network_name}"
  subnetwork = "${module.network.subnetwork_name}"
}

module "gce-lb" {
  source = "../../tf-modules/terraform-google-lb-mod"

  project           = "${var.project}"
  region            = "${var.region}"
  name              = "${var.res_prefix}"
  network           = "${module.network.network_name}"
  service_port_name = "${var.res_prefix}-api-https"
  service_port      = "${module.masters_mig.service_port}"
  instance_group    = "${module.masters_mig.region_instance_group}"
}

module "masters_mig" {
  source = "GoogleCloudPlatform/managed-instance-group/google"

  project                = "${var.project}"
  region                 = "${var.region}"
  zone                   = "${var.zone}"
  name                   = "${var.res_prefix}-masters"
  size                   = "${var.master_group_size}"
  service_port_name      = "${var.res_prefix}-api-https"
  service_port           = "6443"
  target_tags            = ["${var.res_prefix}-nat-${var.region}", "${var.res_prefix}-masters"]
  http_health_check      = false
  zonal                  = false
  service_account_scopes = ["${var.service_account_scopes}"]
  network                = "${module.network.network_name}"
  subnetwork             = "${module.network.subnetwork_name}"
  access_config          = ["${var.access_config}"]
  can_ip_forward         = true
  machine_type           = "${var.master_type}"
  compute_image          = "${var.coreos_image}"

  metadata = {
    "owner" = "${var.owner}"

    "ssh-keys" = "core:${file("${var.pub_key}")}"
  }
}


module "workers_mig" {
  source = "../../tf-modules/terraform-google-managed-instance-group-mod"

  project                = "${var.project}"
  region                 = "${var.region}"
  zone                   = "${var.zone}"
  name                   = "${var.res_prefix}-workers"
  size                   = "${var.worker_group_size}"
  target_tags            = ["${var.res_prefix}-nat-${var.region}", "${var.res_prefix}-workers"]
  http_health_check      = false
  zonal                  = false
  service_account_scopes = ["${var.service_account_scopes}"]
  network                = "${module.network.network_name}"
  subnetwork             = "${module.network.subnetwork_name}"
  access_config          = ["${var.access_config}"]
  can_ip_forward         = true
  machine_type           = "${var.master_type}"
  compute_image          = "${var.coreos_image}"

  metadata = {
    "owner" = "${var.owner}"

    "ssh-keys" = "core:${file("${var.pub_key}")}"
  }
}

module "bastion" {
  source = "../../tf-modules/gce-custom-kubernetes"

  pub_key           = "${var.pub_key}"
  jumpbox_type      = "${var.jumpbox_type}"
  region            = "${var.region}"
  subnet_cidr       = "${var.subnet_cidr}"
  jumpbox_image     = "${var.jumpbox_image}"
  res_prefix        = "${var.res_prefix}"
  project           = "${var.project}"
  owner             = "${var.owner}"
  cluster_zones     = "${var.cluster_zones}"
  network           = "${module.network.network_name}"
  subnetwork        = "${module.network.subnetwork_name}"
  jumpbox_create    = true
}
