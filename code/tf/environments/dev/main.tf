# DEV root module for the rc-saas reference estate.
#
# This is the composition the child modules under code/tf/ are written for. It
# is deliberately small: Google's rule is to keep a root configuration under
# 100 resources and ideally in the low dozens, because plan time, lock
# contention, and the size of a single mistaken apply all scale with it (26.5).

module "network" {
  source = "../../network"

  project_id  = var.host_project_id
  name_prefix = "rc-saas-dev"
  subnets     = var.subnets
}

module "project_iam" {
  source = "../../project-iam"

  project_id = var.project_id
  bindings   = var.iam_bindings
}

# No org_policy_baseline here. The baseline is applied ONCE for the whole
# estate, from the bootstrap layer -- an organization-scoped policy is not an
# environment's to own, and applying it from three environments would mean
# three states fighting over one object (31.1).

output "network_id" {
  value       = module.network.network_id
  description = "Self-link of the VPC the service projects attach to."
}

output "subnet_ids" {
  value       = module.network.subnet_ids
  description = "Subnet ids, keyed as they were supplied."
}
