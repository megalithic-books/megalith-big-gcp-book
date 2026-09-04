# Compatibility

## What the book was verified against

Every command in the book was resolved against the installed tool rather than from documentation,
and every IAM role, permission, and organization policy constraint was checked against Google's own
reference. These are the exact versions that produced those results.

| Tool | Version | Notes |
|---|---|---|
| Google Cloud SDK | **583.0.0** | `core 2026.08.31` |
| — `alpha` component | `2026.08.31` | installed; used by exactly one command in the book |
| — `beta` component | `2026.08.31` | installed; used by exactly one command in the book |
| — `bq` | 2.1.38 | |
| — `gsutil` | 5.37 | |
| — `kubectl` | 1.35.3 | |
| — `gke-gcloud-auth-plugin` | 0.5.19 | |
| Terraform | **1.15.8** | |
| OpenTofu | **1.12.6** | Chapter 27 is written as a diff against Terraform, not a parallel chapter |
| `hashicorp/google` provider | **`~> 8.0`** | major 8 confirmed current 2026-09-03; pinned in every complete example |
| ansible-core | **2.21.3** | |
| `google.cloud` collection | **1.14.0** | 194 modules |

Console navigation and product behavior reflect the Google Cloud surface **as of 2026-09**.

## Things that were true at press time and will not stay true

These are the claims most likely to age, listed so you can check them rather than discover them.

**Launch stages.** The book labels every Preview surface explicitly and says it must not be a
production dependency. Several will have gone GA:

- Cloud KMS Autokey was GA, with its two modes renamed in 2026 — "dedicated-project key storage"
  (was centralized) and "same-project key storage" (was delegated).
- Cloud Run worker pools reached GA on 2026-04-14; Direct VPC egress on 2024-04-24.
- The **Admin, Writer, and Reader basic roles are Preview** and cannot be granted from the console.
- Binary Authorization continuous validation is Preview and **only logs — it does not block**.

**Things Google had not published.** The book does not invent numbers to fill these:

- **No failover RTO is published for Cloud SQL.** The high-availability page says "about sixty
  seconds" and immediately adds that it varies by environment. Every RTO and RPO in this book is a
  number you set and measure.
- **No total count of built-in infoTypes.** The reference directs callers to `infoTypes.list`.
- **No CIS control number could be confirmed at any version**, so the book prints none. The CIS
  Google Cloud Foundation Benchmark was at v5.0.0 while Security Health Analytics mapped to v2.0.0,
  the posture template was `cis_2_0`, and Audit Manager reported v3.0.

**Announced end-of-life.** Security Command Center's **Enterprise tier shuts down on 2027-05-21**.
The book never presents it as a target state.

**Volatile lists the book deliberately points at rather than reproduces:** GKE Enterprise pricing,
the services with GA Key Access Justifications integration, and the Assured Workloads control
packages. Each is a page reference in the text, not a table.

## Command surfaces that did not exist at press time

Verified absent, so do not "correct" the book toward them without checking first:

- `gcloud artifacts docker images sign`
- `gcloud deploy rollouts rollback` (the rollback is `gcloud deploy targets rollback`)
- `gcloud org-policies allow` and `gcloud org-policies deny` (every write goes through `set-policy`
  and a file)
- `gcloud container analysis` (Container Analysis notes are REST-only)
- `gcloud support cases`

One SDK quirk worth knowing: **`gcloud deploy deploy-policies --help` omits `list` from its
subcommand index**, although `gcloud deploy deploy-policies list` resolves and accepts `--region`.
A validator that walks the subcommand index will report a false negative there.
