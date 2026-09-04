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
    network/              Shared VPC host network: subnets, secondary ranges, flow logs
    org-policy-baseline/  The organization policy manifest of Appendix C
    project-iam/          Additive-only project IAM bindings
  ansible/
    inventory/            Dynamic inventory (gcp_compute) and group vars
    roles/os-baseline/    The CIS-derived host baseline of 28.12
```

**The Terraform directories are child modules.** They declare a minimum provider version and
configure no provider and no backend — the root module owns both. That is deliberate: a module
that pins a provider or names a backend cannot be composed. See 26.27–26.34 for the module design
argument.

Every complete example pins `hashicorp/google` at `~> 8.0`.

### Running them

These are teaching modules, not a landing zone. They are written against the book's two reference
estates (`rc-saas` and `rc-ent`) and use placeholder identifiers throughout — `PROJECT_ID`,
`123456789012`, `rickcollette.domain`, and RFC 1918 / RFC 5737 addresses. **Nothing here resolves
to a real host or a real organization.** Substitute your own before applying anything.

Read the section that introduces a module before you run it. Several of these create resources
that cost money, and a few — organization policy in particular — change behavior estate-wide.

## Reporting an error

Open an issue with the **page number and the printing** (`book-version`). Confirmed corrections go
to `docs/errata.md` with the printing they were found in and the printing they were fixed in.

## Author

Rick Collette — https://rickcollette.org
