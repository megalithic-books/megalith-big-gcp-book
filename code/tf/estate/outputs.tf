output "folder_ids" {
  value       = local.folder_names
  description = "Folder resource names keyed as they were declared, e.g. fldr-common."
}

output "project_ids" {
  value       = { for k, p in google_project.this : k => p.project_id }
  description = "Project IDs actually created."
}

output "project_numbers" {
  value       = { for k, p in google_project.this : k => p.number }
  description = <<-EOT
    Project NUMBERS. VPC Service Controls perimeters and Workload Identity
    principal sets are addressed by number, not ID (20.2, 4.3), so this output
    is what those configurations consume.
  EOT
}
