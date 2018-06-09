output "network" {
value = "${module.network.network_name}"
}

output "subnetwork" {
value = "${module.network.subnetwork_name}"
}

output "master_instance_group" {
value = "${module.masters_mig.region_instance_group}"
}

output "worker_instance_group" {
value = "${module.workers_mig.region_instance_group}"
}

output "bastion_ip" {
value = "${module.bastion.jumpbox_ip}"
}

output "lb_ip" {
value = "${module.gce-lb.external_ip}"
}
