# A ROOT module. Unlike the child modules under code/tf/, this one owns the
# provider and the backend -- that is what makes it a root module (26.5).
terraform {
  required_version = ">= 1.11"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 8.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}
