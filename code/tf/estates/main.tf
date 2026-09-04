# Appendix A's seven estate layouts, as configuration.
#
# The appendix presents them as designs at seven scales; the difference between
# them is folder structure and project count, not resource types. So this is one
# root module and seven tfvars files -- a1-small-saas.tfvars through
# a7-multi-cloud.tfvars -- rather than seven near-identical configurations.
#
#   terraform plan -var-file=a1-small-saas.tfvars
#   terraform plan -var-file=a4-large-enterprise.tfvars
#
# Creating an estate is a bootstrap activity: it runs once, by a human with
# impersonation, before the pipeline that will manage everything else exists
# (26.4). It is deliberately not wired to a shared backend here.

terraform {
  required_version = ">= 1.11"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 8.0"
    }
  }
}

provider "google" {}

variable "org_id" { type = string }
variable "billing_account" { type = string }

variable "folders" {
  type = map(object({
    display_name = string
    parent       = optional(string)
  }))
}

variable "projects" {
  type = map(object({
    folder = string
    labels = map(string)
  }))
}

module "estate" {
  source = "../estate"

  org_id          = var.org_id
  billing_account = var.billing_account
  folders         = var.folders
  projects        = var.projects
}

output "folder_ids" { value = module.estate.folder_ids }
output "project_ids" { value = module.estate.project_ids }
output "project_numbers" { value = module.estate.project_numbers }
