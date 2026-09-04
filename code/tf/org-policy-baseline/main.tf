terraform {
  required_version = ">= 1.5"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 8.0"
    }
  }
}

variable "org_id" {
  description = "Organization ID the baseline is applied to."
  type        = string
}

locals {
  parent = "organizations/${var.org_id}"
}

# Boolean and managed constraints enforced estate-wide. Every constraint ID here
# is the bare form; the "constraints/" prefix is not used in the resource name.
# See Appendix C for the manifest and Chapter 31 for the argument behind each.
locals {
  enforced = [
    "cloudbuild.disableCreateDefaultServiceAccount",
    "cloudbuild.useBuildServiceAccount",
    "cloudbuild.useComputeServiceAccount",
    "cloudkms.disableBeforeDestroy",
    "compute.disableInternetNetworkEndpointGroup",
    "compute.disableSerialPortAccess",
    "compute.disableSerialPortLogging",
    "compute.disableVpcExternalIpv6",
    "compute.managed.disableSerialPortAccess",
    "compute.managed.requireOsConfig",
    "compute.managed.requireOsLogin",
    "compute.managed.restrictNonConfidentialComputing",
    "compute.managed.restrictProtocolForwardingCreationForTypes",
    "compute.managed.vmExternalIpAccess",
    "compute.requireOsLogin",
    "compute.requireShieldedVm",
    "compute.setNewProjectDefaultToZonalDNSOnly",
    "compute.skipDefaultNetworkCreation",
    "container.managed.disableABAC",
    "container.managed.disableInsecureKubeletReadOnlyPort",
    "container.managed.disableRBACSystemBindings",
    "container.managed.disallowDefaultComputeServiceAccount",
    "container.managed.enableBinaryAuthorization",
    "container.managed.enableGoogleGroupsRBAC",
    "container.managed.enableNetworkPolicy",
    "container.managed.enablePrivateNodes",
    "container.managed.enableSecretsEncryption",
    "container.managed.enableShieldedNodes",
    "container.managed.enableWorkloadIdentityFederation",
    "essentialcontacts.managed.allowedContactDomains",
    "gcp.detailedAuditLoggingMode",
    "iam.automaticIamGrantsForDefaultServiceAccounts",
    "iam.disableAuditLoggingExemption",
    "iam.disableServiceAccountKeyCreation",
    "iam.disableServiceAccountKeyUpload",
    "iam.managed.allowedPolicyMembers",
    "iam.managed.disableServiceAccountCreation",
    "iam.managed.disableServiceAccountKeyCreation",
    "iam.managed.disableServiceAccountKeyUpload",
    "iam.managed.preventPrivilegedBasicRolesForDefaultServiceAccounts",
    "run.managed.requireInvokerIam",
    "sql.managed.restrictAuthorizedNetworks",
    "sql.managed.restrictPublicIp",
    "sql.restrictAuthorizedNetworks",
    "sql.restrictPublicIp",
    "storage.publicAccessPrevention",
    "storage.secureHttpTransport",
    "storage.uniformBucketLevelAccess",
  ]
}

resource "google_org_policy_policy" "enforced" {
  for_each = toset(local.enforced)

  name   = "${local.parent}/policies/${each.value}"
  parent = local.parent

  spec {
    rules {
      enforce = "TRUE"
    }
  }
}

# List constraints carry values and are declared individually, because the value
# is the decision. Scope overrides (folder rather than organization) are noted in
# Appendix C and are applied by pointing "parent" at the folder instead.

resource "google_org_policy_policy" "resource_locations" {
  name   = "${local.parent}/policies/gcp.resourceLocations"
  parent = local.parent

  spec {
    rules {
      values {
        allowed_values = ["in:us-locations", "in:eu-locations"]
      }
    }
  }
}

resource "google_org_policy_policy" "vm_external_ip" {
  name   = "${local.parent}/policies/compute.vmExternalIpAccess"
  parent = local.parent

  spec {
    rules {
      deny_all = "TRUE"
    }
  }
}

resource "google_org_policy_policy" "flow_logs" {
  name   = "${local.parent}/policies/compute.requireVpcFlowLogs"
  parent = local.parent

  spec {
    rules {
      values {
        allowed_values = ["COMPREHENSIVE"]
      }
    }
  }
}
