output "network_name" {
  value = "${google_compute_network.kubespray-nw.name}"
}

output "subnetwork_name" {
  value = "${google_compute_subnetwork.kubespray-subnet.name}"
}

output "network_link" {
  value = "${google_compute_network.kubespray-nw.self_link}"
}

output "subnetwork_link" {
  value = "${google_compute_subnetwork.kubespray-subnet.self_link}"
}
