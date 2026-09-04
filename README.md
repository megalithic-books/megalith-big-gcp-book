# megalith's Big GCP Book — companion repository

Code examples, errata, and compatibility notes for
**megalith's Big GCP Book: A SecDevOps Guide to Google Cloud Platform** by Rick Collette.

This repository does **not** contain the book. It contains the reusable material the book refers
to by path, plus the corrections and version notes that accumulate after a book is printed.

| Path | What it is |
|---|---|
| `code/tf/` | Terraform / OpenTofu modules referenced from the chapters |
| `code/ansible/` | Ansible inventory, group vars, and the `os-baseline` role |
| `docs/errata.md` | Corrections to the printed text |
| `docs/compatibility.md` | The exact toolchain the book was verified against, and what has moved since |
| `docs/migrations.md` | What to change when a version moves past what the book verified |
| `book-version` | Which printing this repository matches |

## The code

Long, reusable examples live here rather than in the book, so that a page of print is not spent on
something you would copy rather than read. Short illustrative snippets stay inline in the chapters.

```
code/
  tf/
    network/              Shared VPC host network: subnets, secondary ranges, flow logs (§5.28, §26.28)
    org-policy-baseline/  The organization policy manifest of Appendix C
    project-iam/          Additive-only project IAM bindings (§3.11, §26.29)
  ansible/
    inventory/            Dynamic inventory (gcp_compute) and group vars (§28.3)
    roles/os-baseline/    The CIS-derived host baseline (§28.12)
    requirements.yml      Collections pinned to the verified versions
```

**Chapters reference these by path.** When a section says the configuration is in
`code/tf/network/`, that is this directory.

## What this is, and what it is not

**These are the reusable modules the chapters point at. They are not a landing zone, and running
them will not stand up the estate the book describes.**

The Terraform directories are **child modules**: each declares a minimum provider version and
configures no provider and no backend, because the root module owns both (§26.5). To use them you
supply the composition — a root module per environment, with its own backend and state, as §26.5
sets out:

```text
terraform/
  environments/
    prod/   backend.tf  main.tf  terraform.tfvars  versions.tf
```

That composition is deliberately not shipped here. The backend bucket, the project IDs, the CIDR
allocation, and the organization ID are estate-specific, and a module that invents them is a module
that collides with something you already have (§5.6).

**Appendix A gives seven estate layouts.** None of them is provided as runnable code. They are
designs to build from, and the chapter that owns each mechanic is cited from the appendix.

### Roughly, what is here

| The book covers | Code here |
|---|---|
| Networking, Shared VPC | `code/tf/network/` |
| IAM bindings | `code/tf/project-iam/` |
| Organization policy | `code/tf/org-policy-baseline/` |
| Host configuration | `code/ansible/roles/os-baseline/`, `code/ansible/inventory/` |
| GKE, Cloud Run, storage, databases, KMS, Secret Manager, logging, monitoring, CI/CD, supply chain | **the chapters, inline** |

The chapters carry working `gcloud` and HCL for those services; what is not here is a packaged
module for each. If you want one, the chapter that describes the service is the specification.

## Running any of this

These are teaching modules. They are written against the book's two reference estates (`rc-saas`
and `rc-ent`) and use placeholder identifiers throughout — `PROJECT_ID`, `123456789012`,
`rickcollette.domain`, and RFC 1918 / RFC 5737 addresses. **Nothing here resolves to a real host or
a real organization.** Substitute your own before applying anything.

Read the section that introduces a module before you run it. Several create resources that cost
money, and the organization policy baseline changes behavior estate-wide — roll it out with
`dry_run_spec` first (§20.8, §31.1).

## Reporting an error

Open an issue with the **page number and the printing** (`book-version`). Confirmed corrections go
to `docs/errata.md` with the printing they were found in and the printing they were fixed in.

## Author

Rick Collette — https://rickcollette.org
