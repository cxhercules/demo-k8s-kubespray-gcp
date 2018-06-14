variable "pub_key" {}
variable "api_key" {}
variable "region" {}
variable "project" {}
variable "res_prefix" {}
variable "subnet_cidr" {}
variable "jumpbox_create" {}
variable "jumpbox_type" {}
variable "jumpbox_image" {}
variable "os_image" {}
variable "owner" {}
variable "master_type" {}
variable "master_group_size" {}
variable "worker_type" {}
variable "worker_group_size" {}
variable "update_strategy" {}
variable "zone" {}

variable "service_account_scopes" {
  default = []
}

variable "access_config" {
  default = []
}

variable "cluster_zones" {
  default = []
}
