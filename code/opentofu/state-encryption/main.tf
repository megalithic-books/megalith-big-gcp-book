# Client-side state encryption. This is an OpenTofu capability that Terraform
# does NOT have -- verified by running the same configuration through both
# binaries (27.5, 27.9, 27.11). It is the reason this directory exists: the rest
# of the OpenTofu surface is the same as Terraform and is not duplicated here.
#
# The state is encrypted before it reaches the backend, so a reader of the
# bucket sees ciphertext. That is a different guarantee from the bucket's own
# CMEK, which protects the object at rest but not from anyone who can read it.

terraform {
  required_version = ">= 1.11"

  encryption {
    key_provider "gcp_kms" "state" {
      kms_encryption_key = join("/", [
        "projects/rc-saas-shared-sec-01/locations/us-central1",
        "keyRings/kr-us-central1-state",
        "cryptoKeys/k-tofu-state",
      ])

      # AES-GCM wants 32 bytes. This is a required argument, not a default.
      key_length = 32
    }

    method "aes_gcm" "state" {
      keys = key_provider.gcp_kms.state
    }

    state {
      method   = method.aes_gcm.state
      enforced = true
    }

    # The plan file carries the same values the state does. Encrypting state and
    # leaving plans in the clear protects the wrong artifact (26.17).
    plan {
      method   = method.aes_gcm.state
      enforced = true
    }
  }
}
