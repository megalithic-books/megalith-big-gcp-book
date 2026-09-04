# Migrations

What to change when a version moves past what the book verified. `docs/compatibility.md` records
what those versions were.

This file covers **changes that invalidate something the book says**. Routine upgrades that change
nothing in the text are not listed.

## When the `hashicorp/google` provider goes to major 9

Every complete example in the book pins `~> 8.0`. Major 8 was current on 2026-09-03 and the pin is
deliberate: an unpinned provider is a configuration whose behavior changes without a commit.

When you move, expect the break to be in **arguments the book relies on**, not in the resources
themselves. Check these first, because each carries a claim the book makes:

- `google_org_policy_policy` — `enforce`, `allow_all`, and `deny_all` are the **quoted strings**
  `"TRUE"`/`"FALSE"` in major 8, while `inherit_from_parent` and `reset` are real booleans. If that
  asymmetry is resolved in a later major, Appendix C's manifest and
  `code/tf/org-policy-baseline/` both change.
- **Write-only arguments** (`secret_data_wo`, `password_wo`, and their `_version` counters) and
  `ephemeral` resources — §13.13's whole pattern. These arrived in Terraform 1.11 and OpenTofu
  1.11; a provider that drops or renames them changes the recommended way to keep a secret out of
  state.
- `google_project_iam_member` — §3.11 and `code/tf/project-iam/` depend on it staying **additive**.

## When Terraform and OpenTofu diverge further

Chapter 27 is written as a **diff** against Terraform, not a parallel chapter, so it ages
differently. What was true at press time:

- State round-trips in **both directions** between Terraform 1.15.8 and OpenTofu 1.12.6; both write
  format version 4. The real incompatibility is the **provider source address in the lock file**,
  not the state.
- **Client-side state encryption is an OpenTofu capability that Terraform does not have.** Proved by
  running the same `encryption {}` configuration through both binaries.
- `registry.opentofu.org` is **not a mirror**. It serves binaries built from the same source by the
  OpenTofu project, signed with key `0C0AF313E5FD9F80`, explicitly not byte-for-byte identical to
  HashiCorp's. That is a trust-anchor decision, and it is the thing to re-check on any move.

## When a Preview surface goes GA

The book labels every Preview surface and says it must not be a production dependency. That
sentence is the thing to revisit, not the mechanics. `docs/compatibility.md` lists the ones most
likely to have moved.

The reverse also happens: **Security Command Center's Enterprise tier shuts down on 2027-05-21**.
The book never presents it as a target state, so nothing in the text depends on it surviving.

## When the `google.cloud` Ansible collection changes

Pinned at **1.14.0** in `code/ansible/requirements.yml`. Two facts to re-check on any upgrade:

- **No `google.cloud` resource module supports check mode.** All 79 modules that declare it are
  `*_info` modules, which is why `ansible-playbook --check` skips every provisioning task and why
  this book provisions with Terraform and configures with Ansible (§28.2). If that changes, §28.2's
  argument weakens.
- `auth_kind` accepts `application`, `machineaccount`, `serviceaccount`, and `accesstoken`. Three
  are keyless; `service_account_email` works only with `machineaccount`. §28.6 depends on this.

## When `gcloud` command surfaces appear

The book states that several commands **do not exist**, and those statements were verified. If one
appears, the surrounding guidance changes rather than just the command:

| Absent at press time | What the book does instead |
|---|---|
| `gcloud artifacts docker images sign` | Binary Authorization attestation path (§37.6) |
| `gcloud deploy rollouts rollback` | `gcloud deploy targets rollback` (§25.x) |
| `gcloud org-policies allow` / `deny` | `set-policy` with a file — every write (§31.1) |
| `gcloud container analysis` | Container Analysis notes are REST-only (§37.7) |
