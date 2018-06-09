# Managed Instance Group Terraform Module

Modular Google Compute Engine managed instance group for Terraform.

## Usage

```ruby
data "template_file" "php-startup-script" {
  template = "${file("${format("%s/../scripts/gceme.sh.tpl", path.module)}")}"
  vars {
    PROXY_PATH = ""
  }
}

module "mig1" {
  source            = "GoogleCloudPlatform/managed-instance-group/google"
  region            = "${var.region}"
  zone              = "${var.zone}"
  name              = "group1"
  size              = 2
  service_port      = 80
  service_port_name = "http"
  target_pools      = ["${module.gce-lb-fr.target_pool}"]
  target_tags       = ["allow-service1"]
  startup_script    = "${data.template_file.php-startup-script.rendered}"
}
```

## Resources created

- [`google_compute_instance_template.default`](https://www.terraform.io/docs/providers/google/r/compute_instance_template.html): The instance template assigned to the instance group.
- [`google_compute_instance_group_manager.default`](https://www.terraform.io/docs/providers/google/r/compute_instance_group_manager.html): The instange group manager that uses the instance template and target pools. 
- [`google_compute_firewall.default-ssh`](https://www.terraform.io/docs/providers/google/r/compute_firewall.html): Firewall rule to allow ssh access to the instances.
