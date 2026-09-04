variable "project_id" {
  type        = string
  description = "Service project this environment's workloads live in."
}

variable "host_project_id" {
  type        = string
  description = "Shared VPC host project that owns the network (5.28)."
}

variable "region" {
  type        = string
  default     = "us-central1"
  description = "Primary region for the SaaS estate (see decisions in 1.4)."
}

variable "subnets" {
  description = "Subnet allocation. The address plan is an input, never computed (5.6)."
  type = map(object({
    region            = string
    primary_range     = string
    secondary_ranges  = optional(map(string), {})
    flow_log_sampling = optional(number, 0.5)
  }))
}

variable "iam_bindings" {
  type        = map(list(string))
  default     = {}
  description = "Role to group principals. Groups only (3.4); basic roles are rejected."
}
