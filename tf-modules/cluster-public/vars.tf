variable "pub_key" {}
variable "pvt_key" {}
variable "api_key" {}
variable "region" {
  default = "us-central1"
}
variable "project" {}
variable "res_prefix" {}
variable "subnet_cidr" {
  default = "10.128.0.0/20"
}
variable "jumpbox_type" {
  default = "n1-standard-1"
}
variable "jumpbox_image" {
  default = "ubuntu-os-cloud/ubuntu-1604-lts"
}
variable "master_type" {
  default = "n1-standard-1"
}
variable "coreos_image" {
  default = "coreos-stable-1632-3-0-v20180215"
}
variable "owner" {}
variable "master_count" {
  default = "1"
}
variable "worker_type" {
  default = "n1-standard-1"
}
variable "worker_count" {
  default = "1"
}
variable "jumpbox_create" {
  default = false
}
variable "network" {
  default = "default"
}
variable "subnetwork" { 
  default = "default"
}
variable "cluster_zones" {
  default = [
  "us-central1-a", 
  "us-central1-b", 
  "us-central1-c"
  ]
}
