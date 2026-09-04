# org-policy-baseline

The organization policy baseline of **Appendix C**, as one applyable configuration. Chapter 31 owns
the argument for each constraint — why it is set, what it breaks, and which exceptions are
legitimate. This module owns only the application.

## Read this before you apply it

**This changes behavior estate-wide and some of it is not reversible in practice.** An organization
policy denies actions across every project beneath the node it is attached to. Applying the whole
baseline to a live organization in one apply will break things that were relying on the previous
default — that is the point of it, but the order matters (§31.1).

Roll out with the `dry_run_spec` first, read the violations out of the audit log, then enforce.
That is the same discipline §20.8 applies to a VPC Service Controls perimeter, and for the same
reason: the things that break first are all legitimate.

## Structure

The 48 boolean and managed constraints are applied through one `for_each` over `local.enforced`.
The list constraints are declared individually, because with a list constraint the **value is the
decision** and it deserves to be read rather than iterated.

Note that `google_org_policy_policy` takes the constraint **without** the `constraints/` prefix in
its `name`, and that `enforce`, `allow_all`, and `deny_all` are the quoted strings `"TRUE"` and
`"FALSE"` — not HCL booleans. `inherit_from_parent` and `reset` *are* real booleans.

## Usage

```hcl
module "org_policy_baseline" {
  source = "../../modules/org-policy-baseline"
  org_id = "123456789012"
}
```

Scope overrides — the rows Appendix C marks **folder** rather than **org** — are applied by
pointing `parent` at the folder instead. `constraints/gcp.resourceLocations` is the main one:
§31.2 says apply it at a folder unless the whole estate is single-jurisdiction.
