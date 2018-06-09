/*
 * Copyright 2017 Google Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

resource "google_compute_target_tcp_proxy" "default" {
  name            = "${var.name}-tcp-proxy"
  description     = "${var.name} lb tcp proxy"
  backend_service = "${google_compute_backend_service.default.self_link}"
}

resource "google_compute_backend_service" "default" {
  name        = "${var.name}-backend"
  protocol    = "TCP"
  port_name   = "${var.service_port_name}"
  timeout_sec = 10

  backend {
    group = "${var.instance_group}"
  }

  health_checks = ["${google_compute_health_check.default.self_link}"]
}

resource "google_compute_health_check" "default" {
  name               = "${var.name}-hc"
  timeout_sec        = 5
  check_interval_sec = 5

  tcp_health_check {
    port = "${var.service_port}"
  }
}

// Static IP address for HTTP forwarding rule
resource "google_compute_global_address" "default" {
  name = "${var.name}-ip"
}

resource "google_compute_global_forwarding_rule" "default" {
  project     = "${var.project}"
  name        = "${var.name}-frontend"
  target      = "${google_compute_target_tcp_proxy.default.self_link}"
  port_range  = "443"
  ip_protocol = "TCP"
  ip_address  = "${google_compute_global_address.default.address}"
}

resource "google_compute_firewall" "default-lb-fw" {
  project = "${var.firewall_project == "" ? var.project : var.firewall_project}"
  name    = "${var.name}-${var.service_port}-service"
  network = "${var.network}"

  allow {
    protocol = "tcp"
    ports    = ["${var.service_port}"]
  }

  source_ranges = ["0.0.0.0/0"]
}
