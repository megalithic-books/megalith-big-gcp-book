# OpenTofu

**Only what genuinely differs from Terraform lives here.** Chapter 27 is written as a diff, not a
parallel chapter, and this directory follows the same rule: everything under `code/tf/` runs
unchanged under OpenTofu, so it is not duplicated.

| Directory | Why it is here |
|---|---|
| `state-encryption/` | Client-side state and plan encryption. **Terraform has no equivalent** (§27.5, §27.11). |

## What was verified

- **State round-trips in both directions** between Terraform 1.15.8 and OpenTofu 1.12.6; both write
  format version 4. The real incompatibility is the **provider source address in the lock file**,
  not the state (§27.6).
- **OpenTofu 1.11 added ephemeral values and write-only attributes**, so §13.13's pattern for keeping
  secrets out of state works unchanged under either binary.
- `registry.opentofu.org` is **not a mirror**. It serves binaries built from the same source by the
  OpenTofu project and signed with key `0C0AF313E5FD9F80`, explicitly not byte-for-byte identical to
  HashiCorp's (§27.3). That is a trust-anchor decision, not a formality.

The provider pin is `hashicorp/google ~> 8.0` here too: OpenTofu resolves the same provider from its
own registry and the pin syntax is identical.
