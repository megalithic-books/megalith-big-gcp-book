locals {
  required_apis = var.enable_apis ? toset([
    "compute.googleapis.com",
    "networkmanagement.googleapis.com",
  ]) : toset([])
}

resource "google_project_service" "required" {
  for_each = local.required_apis

  project = var.project_id
  service = each.value

  # Required by the shared-module rule: destroying one instance of this module
  # must not disable an API another instance in the same project still needs.
  disable_on_destroy = false
}

resource "google_compute_network" "main" {
  project                 = var.project_id
  name                    = "${var.name_prefix}-vpc"
  auto_create_subnetworks = false
  routing_mode            = "GLOBAL"

  # Cloud NGFW policies are evaluated before legacy rules (see 5.13).
  network_firewall_policy_enforcement_order = "BEFORE_CLASSIC_FIREWALL"

  depends_on = [google_project_service.required]
}

resource "google_compute_subnetwork" "main" {
  for_each = var.subnets

  project                  = var.project_id
  name                     = "${var.name_prefix}-${each.key}"
  network                  = google_compute_network.main.id
  region                   = each.value.region
  ip_cidr_range            = each.value.primary_range
  private_ip_google_access = true

  dynamic "secondary_ip_range" {
    for_each = each.value.secondary_ranges

    content {
      range_name    = secondary_ip_range.key
      ip_cidr_range = secondary_ip_range.value
    }
  }

  log_config {
    aggregation_interval = "INTERVAL_5_SEC"
    flow_sampling        = each.value.flow_log_sampling
    metadata             = "INCLUDE_ALL_METADATA"
  }
}
