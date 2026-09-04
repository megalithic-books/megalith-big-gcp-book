# Changelog

Changes to the book and to this repository. The book's printing is tracked in `book-version`;
corrections to the printed text are in `docs/errata.md`.

Versioning follows the printing, not semver: **major** is an edition, **minor** is a reprint with
text changes, **patch** is a change to this repository only.

## [Unreleased]

## [1.0.0] — first edition

**megalith's Big GCP Book: A SecDevOps Guide to Google Cloud Platform.**
44 units — 37 chapters and 7 appendices — 789 sections, 754 pages.

Verified against Google Cloud SDK 583.0.0, Terraform 1.15.8, OpenTofu 1.12.6, ansible-core 2.21.3,
and the `google.cloud` collection 1.14.0, with `hashicorp/google` pinned at `~> 8.0`. Console
navigation and product behavior reflect the Google Cloud surface as of 2026-09. The full matrix is
in `docs/compatibility.md`.

### Companion code
Covering all eleven repository goals stated in the book's front matter.

- `code/tf/network/` — Shared VPC host network: subnets, GKE secondary ranges, flow logs (§5.28, §26.28)
- `code/tf/project-iam/` — additive-only project IAM bindings, basic roles rejected (§3.11, §26.29)
- `code/tf/org-policy-baseline/` — the Appendix C organization policy manifest
- `code/tf/environments/prod/` — **root module** composing the three, with backend and provider (§26.5, §26.18)
- `code/opentofu/state-encryption/` — client-side state and plan encryption, which Terraform does not have (§27.5, §27.11)
- `code/ansible/inventory/` — `gcp_compute` dynamic inventory and group vars (§28.3)
- `code/ansible/playbooks/site.yml` — convergence plus read-back assertions (§28.12, §28.21)
- `code/ansible/roles/os-baseline/` — the CIS-derived host baseline (§28.12)
- `code/ansible/requirements.yml` — collections pinned to the verified versions
- `code/kubernetes/` — Pod Security Admission, default-deny NetworkPolicy, Workload Identity ServiceAccount (§9.11, §9.14, §9.15)
- `code/policies/` — org policy `set-policy` documents, Binary Authorization policy, IAM deny policy (§3.17, §25.10, §31.1)
- `code/cicd/` — Cloud Build pipeline and GitHub Actions with Workload Identity Federation (§4.7, §23.x)
- `code/scripts/verify-baseline.sh` — reads the baseline back with `--effective` (§29.11, §31.1)

Every Terraform and OpenTofu configuration passes `validate`; every YAML and JSON file parses;
the Ansible role and playbook pass `--syntax-check`; the sshd template is accepted by `sshd -t`;
every shell script passes `bash -n`; and every `roles/`, `constraints/`, and `§` identifier is
checked against the book's own references.
