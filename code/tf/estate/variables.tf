variable "org_id" {
  type        = string
  description = "Organization the estate is created under, digits only."

  validation {
    condition     = can(regex("^[0-9]+$", var.org_id))
    error_message = "org_id is the numeric organization ID, without the organizations/ prefix."
  }
}

variable "billing_account" {
  type        = string
  description = "Billing account the projects are linked to."
}

variable "folders" {
  description = <<-EOT
    The folder hierarchy, keyed by a short name used to reference it elsewhere.
    `parent` is another folder's key, or null for a folder directly under the
    organization. Depth is capped at four levels, which is the deepest layout in
    Appendix A and well inside the ten-level limit of 2.8.
  EOT

  type = map(object({
    display_name = string
    parent       = optional(string)
  }))
}

variable "projects" {
  description = <<-EOT
    Projects, keyed by project ID. `folder` is a key from var.folders.

    Labels are required on every project in this estate: env, owner,
    cost-center, data-class, system (2.12). The validation below enforces the
    first three; the rest are estate policy rather than a module concern.
  EOT

  type = map(object({
    folder = string
    labels = map(string)
  }))

  validation {
    condition = alltrue([
      for p in var.projects : alltrue([
        for k in ["env", "owner", "cost-center"] : contains(keys(p.labels), k)
      ])
    ])
    error_message = "Every project needs at least the env, owner and cost-center labels (2.12)."
  }

  validation {
    condition     = alltrue([for id in keys(var.projects) : length(id) <= 30])
    error_message = "A project ID is at most 30 characters (2.11)."
  }
}

variable "deletion_policy" {
  type        = string
  default     = "PREVENT"
  description = <<-EOT
    Applied to every project. PREVENT is the default here on purpose: a project
    is the blast-radius unit, and `terraform destroy` reaching one by accident
    is the failure this guards (2.29).
  EOT
}
