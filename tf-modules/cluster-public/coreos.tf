resource "google_compute_instance" "coreos_masters" {
  count        = "${var.master_count}"
  name         = "${var.res_prefix}-master-${count.index + 1}"
  machine_type = "${var.master_type}"
  zone         = "${var.cluster_zones[count.index]}"
  tags         = ["nat-${var.region}", "${var.res_prefix}-masters"]

  boot_disk {
    initialize_params {
      image = "${var.coreos_image}"
      size  = "20"
    }
  }

  can_ip_forward = "true"

  // Local SSD disk
  scratch_disk {}

  network_interface {
    subnetwork = "${var.subnetwork}"
    access_config = {}
  }

  metadata {
    owner    = "${var.owner}"
    ssh-keys = "core:${file("${var.pub_key}")}"
  }

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
}

resource "google_compute_instance" "coreos_workers" {
  count        = "${var.worker_count}"
  name         = "${var.res_prefix}-worker-${count.index + 1}"
  machine_type = "${var.worker_type}"
  zone         = "${var.cluster_zones[count.index % length(var.cluster_zones)]}"
  tags         = ["nat-${var.region}"]

  boot_disk {
    initialize_params {
      image = "${var.coreos_image}"
      size  = "200"
    }
  }

  can_ip_forward = "true"

  // Local SSD disk
  scratch_disk {}

  network_interface {
    subnetwork = "${var.subnetwork}"
    access_config = {}
  }

  metadata {
    owner    = "${var.owner}"
    ssh-keys = "core:${file("${var.pub_key}")}"
  }

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
}
