resource "google_compute_firewall" "kubespray-ext" {
  count   = "${var.jumpbox_create ? 1 : 0}"
  name    = "${var.res_prefix}-ext-fw"
  network = "${var.network}"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  target_tags = ["jumpbox"]
}

resource "google_compute_firewall" "kubespray-int" {
  name    = "${var.res_prefix}-int-fw"
  network = "${var.network}"

  allow {
    protocol = "all"
  }

  source_ranges = ["${var.subnet_cidr}"]
}

resource "google_compute_firewall" "kubespray-int-egress" {
  name    = "${var.res_prefix}-int-egress-fw"
  network = "${var.network}"

  allow {
    protocol = "all"
  }

  direction          = "EGRESS"
  destination_ranges = ["0.0.0.0/0"]
}
