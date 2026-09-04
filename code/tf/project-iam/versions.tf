# A shared module declares its minimum provider version and configures
# no providers and no backend. The root module owns both.

terraform {
  required_version = ">= 1.11"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 8.0"
    }
  }
}
