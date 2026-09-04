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
- `code/tf/network/` — Shared VPC host network: subnets, GKE secondary ranges, flow logs (§5.28, §26.28)
- `code/tf/project-iam/` — additive-only project IAM bindings (§3.11, §26.29)
- `code/tf/org-policy-baseline/` — the Appendix C organization policy manifest as one configuration
- `code/ansible/inventory/` — `gcp_compute` dynamic inventory and group vars (§28.3)
- `code/ansible/roles/os-baseline/` — the CIS-derived host baseline (§28.12)
- `code/ansible/requirements.yml` — pinned collections
