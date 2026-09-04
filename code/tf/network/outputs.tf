# Every resource gets at least one output referencing it, so a caller can
# express a real dependency rather than a string it assembled itself.

output "network_id" {
  description = "Fully qualified network ID, for resources attaching to the VPC."
  value       = google_compute_network.main.id
}

output "network_self_link" {
  description = "Self link, for APIs that require that form."
  value       = google_compute_network.main.self_link
}

output "subnet_ids" {
  description = "Map of subnet key to fully qualified subnetwork ID."
  value       = { for k, s in google_compute_subnetwork.main : k => s.id }
}

output "subnet_secondary_ranges" {
  description = "Secondary range names per subnet, for GKE callers (see 9.7)."
  value = {
    for k, s in google_compute_subnetwork.main :
    k => [for r in s.secondary_ip_range : r.range_name]
  }
}
