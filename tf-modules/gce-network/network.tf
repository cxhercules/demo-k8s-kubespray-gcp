resource "google_compute_network" "kubespray-nw" {
  name                    = "${var.res_prefix}-nw"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "kubespray-subnet" {
  name          = "${var.res_prefix}-subnet"
  ip_cidr_range = "${var.subnet_cidr}"
  network       = "${google_compute_network.kubespray-nw.self_link}"
  region        = "${var.region}"
}
