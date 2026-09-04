# Production root module for the rc-saas reference estate.
#
# This is the composition the child modules under code/tf/ are written for. It
# is deliberately small: Google's rule is to keep a root configuration under
# 100 resources and ideally in the low dozens, because plan time, lock
# contention, and the size of a single mistaken apply all scale with it (26.5).

module "network" {
  source = "../../network"

  project_id  = var.host_project_id
  name_prefix = "rc-saas-prod"
  subnets     = var.subnets
}

module "project_iam" {
  source = "../../project-iam"

  project_id = var.project_id
  bindings   = var.iam_bindings
}

# The organization policy baseline is applied ONCE for the whole estate, not
# per environment. It is composed here only so that a reader can see where it
# belongs; in a real estate it lives in the bootstrap layer, because an
# organization-scoped policy is not an environment's to own (31.1).
module "org_policy_baseline" {
  source = "../../org-policy-baseline"

  org_id = var.org_id
}

output "network_id" {
  value       = module.network.network_id
  description = "Self-link of the VPC the service projects attach to."
}

output "subnet_ids" {
  value       = module.network.subnet_ids
  description = "Subnet ids, keyed as they were supplied."
}
