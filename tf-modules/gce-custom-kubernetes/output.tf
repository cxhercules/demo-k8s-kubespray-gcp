output "jumpbox_ip" {
  value = "${ join(" ", google_compute_instance.jumpbox.*.network_interface.0.access_config.0.assigned_nat_ip) }"
}


