# megalith's Big GCP Book — companion repository

Code examples, errata, and compatibility notes for
**megalith's Big GCP Book: A SecDevOps Guide to Google Cloud Platform** by Rick Collette.

This repository does **not** contain the book. It contains the reusable material the book refers
to by path, plus the corrections and version notes that accumulate after a book is printed.

| Path | What it is |
|---|---|
| `code/tf/` | Terraform / OpenTofu modules referenced from the chapters |
| `code/ansible/` | Ansible inventory, group vars, and the `os-baseline` role |
| `docs/sources.md` | **Every URL the book cites, with the date it was last validated** |
| `docs/errata.md` | Corrections to the printed text |
| `docs/compatibility.md` | The exact toolchain the book was verified against, and what has moved since |
| `docs/migrations.md` | What to change when a version moves past what the book verified |
| `book-version` | Which printing this repository matches |

## The code

Long, reusable examples live here rather than in the book, so a page of print is not spent on
something you would copy rather than read. Short illustrative snippets stay inline in the chapters.

```
code/
  tf/
    network/              Shared VPC host network: subnets, secondary ranges, flow logs (§5.28, §26.28)
    project-iam/          Additive-only project IAM bindings (§3.11, §26.29)
    org-policy-baseline/  The organization policy manifest of Appendix C
    environments/          Root modules — dev, stg, prod — the things you run (§26.5, §26.18)
    estate/                Folder and project hierarchy for a whole estate (§2.8, §2.9)
    estates/               Appendix A's seven layouts, as tfvars for that module
  opentofu/
    state-encryption/     Client-side state and plan encryption (§27.5, §27.11)
  ansible/
    inventory/            Dynamic inventory (gcp_compute) and group vars (§28.3)
    playbooks/site.yml    Convergence, plus read-back assertions (§28.12, §28.21)
    roles/os-baseline/    The CIS-derived host baseline (§28.12)
    requirements.yml      Collections pinned to the verified versions
  kubernetes/             Pod Security Admission, default-deny NetworkPolicy,
                          Workload Identity ServiceAccount (§9.11, §9.14, §9.15)
  policies/               Org policy set-policy documents, Binary Authorization
                          policy, IAM deny policy (§3.17, §25.10, §31.1)
  cicd/                   Cloud Build pipeline and GitHub Actions with WIF (§4.7, §23.x)
  scripts/                Read-back verification of the baseline (§31.1, §29.11)
```

**Chapters reference these by path.** When a section says the configuration is in
`code/tf/network/`, that is this directory.

## Standing it up

`code/tf/environments/prod/` is the **root module** — it owns the backend and the provider, and it
composes the three child modules. That is what you run:

```bash
cd code/tf/environments/prod        # or dev, or stg
cp terraform.tfvars.example terraform.tfvars   # then replace every value
terraform init
terraform plan
```

The child modules under `code/tf/` declare a minimum provider version and configure **no provider
and no backend**, because a module that pins either cannot be composed (§26.5). The state bucket
named in `backend.tf` is created by the bootstrap layer, not by this configuration — a root module
cannot create the backend it is already using (§2.21, §26.14).

**The organization policy baseline changes behavior estate-wide.** Roll it out with `dry_run_spec`
first, read the violations out of the audit log, then enforce — the same discipline a VPC Service
Controls perimeter gets, and for the same reason: the things that break first are all legitimate
(§20.8, §31.1).

### The seven estates of Appendix A

They are configuration, not just designs. The difference between them is folder structure and
project count, not resource types, so they are seven **tfvars files** against one module rather than
seven near-identical configurations:

```bash
cd code/tf/estates
terraform plan -var-file=a1-small-saas.tfvars          # 5 folders, 7 projects
terraform plan -var-file=a5-multi-business-unit.tfvars # 13 folders, 3 levels deep
```

| Layout | Folders | Depth | Projects |
|---|---|---|---|
| `a1-small-saas` | 5 | 2 | 7 |
| `a2-large-saas` | 8 | 2 | 16 |
| `a3-small-enterprise` | 8 | 2 | 10 |
| `a4-large-enterprise` | 9 | 2 | 17 |
| `a5-multi-business-unit` | 13 | 3 | 10 |
| `a6-hybrid-cloud` | 6 | 2 | 10 |
| `a7-multi-cloud` | 5 | 2 | 7 |

Creating an estate is a **bootstrap** activity: it runs once, by a human with impersonation, before
the pipeline that manages everything else exists (§26.4). The module refuses a folder nested deeper
than four levels or naming a parent that does not exist, requires the five estate labels on every
project (§2.12), and caps project IDs at 30 characters (§2.11).

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
