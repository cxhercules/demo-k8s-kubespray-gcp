output "jumpbox_ip" {
  value = "${ join(" ", google_compute_instance.jumpbox.*.network_interface.0.access_config.0.assigned_nat_ip) }"
}

output "masters" {
  value = ["${google_compute_instance.coreos_masters.*.self_link}"]
}

output "masters_ips" {
  value = ["${google_compute_instance.coreos_masters.*.network_interface.0.address}"]
}

output "workers_ips" {
  value = ["${google_compute_instance.coreos_workers.*.network_interface.0.address}"]
}
