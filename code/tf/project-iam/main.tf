# Additive IAM only. This module never uses google_project_iam_policy or
# google_project_iam_binding: both are authoritative, and an authoritative
# resource in a reusable module removes bindings the module cannot see --
# including the ones Google's own service agents add automatically.

variable "project_id" {
  type        = string
  description = "Project the bindings apply to."
}

variable "bindings" {
  description = <<-EOT
    Map of role to the principals that hold it. Group principals only:
    binding a role to an individual user is a finding in this estate (3.4).
  EOT
  type        = map(list(string))

  validation {
    condition = alltrue([
      for principals in values(var.bindings) : alltrue([
        for p in principals : !startswith(p, "allUsers") &&
        !startswith(p, "allAuthenticatedUsers")
      ])
    ])
    error_message = "Public principals are not permitted through this module."
  }

  validation {
    # Every predefined and custom role ID carries a service prefix and a dot
    # (roles/compute.admin, projects/.../roles/rc.deployReleaser). The four
    # basic roles do not. Testing for the dot rejects all four without naming
    # them -- and rejects any future basic role for the same reason.
    condition = alltrue([
      for role in keys(var.bindings) : strcontains(role, ".")
    ])
    error_message = "Basic roles are not grantable through this module."
  }
}

locals {
  # Flatten role -> [principals] into one entry per binding so that adding a
  # principal to a role does not re-create the other principals' bindings.
  flattened = merge([
    for role, principals in var.bindings : {
      for p in principals : "${role}|${p}" => {
        role      = role
        principal = p
      }
    }
  ]...)
}

resource "google_project_iam_member" "bindings" {
  for_each = local.flattened

  project = var.project_id
  role    = each.value.role
  member  = each.value.principal
}

output "granted" {
  description = "The bindings actually created, keyed role|principal."
  value       = { for k, b in google_project_iam_member.bindings : k => b.etag }
}
