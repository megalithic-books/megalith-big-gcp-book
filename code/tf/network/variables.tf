variable "project_id" {
  type        = string
  description = "Host project that owns the VPC. No default: callers must be explicit."
}

variable "name_prefix" {
  type        = string
  description = "Prefix for every resource name, e.g. rc-saas-prod."
}

variable "subnets" {
  description = <<-EOT
    Subnets to create. The caller supplies ranges; this module refuses to
    allocate them, because an address plan is an estate-wide decision and a
    module that invents ranges will eventually invent an overlapping one.
  EOT

  type = map(object({
    region            = string
    primary_range     = string
    secondary_ranges  = optional(map(string), {})
    flow_log_sampling = optional(number, 0.5)
  }))

  validation {
    condition = alltrue([
      for s in var.subnets : !startswith(s.primary_range, "0.0.0.0")
    ])
    error_message = "A subnet range must be a real RFC 1918 allocation."
  }
}

variable "enable_apis" {
  type        = bool
  default     = true
  description = "Enable the APIs this module needs. Disableable per the shared-module rule."
}
