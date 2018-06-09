resource "google_compute_instance" "jumpbox" {
  count        = "${var.jumpbox_create ? 1 : 0}"
  name         = "${var.res_prefix}-jumpbox"
  machine_type = "${var.jumpbox_type}"
  zone         = "${var.az}"
  project      = "${var.project}"
  tags         = ["jumpbox"]
  zone         = "${var.cluster_zones[count.index]}"

  boot_disk {
    initialize_params {
      image = "${var.jumpbox_image}"
    }
  }

  metadata {
    ssh-keys = "core:${file("${var.pub_key}")}"
  }

  network_interface {
    subnetwork    = "${var.subnetwork}"
    access_config = {}
  }
}
