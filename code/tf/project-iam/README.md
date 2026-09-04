# project-iam

Additive project IAM bindings. Introduced in §3.11 and used as the module-design worked example in
§26.29.

**This is a child module.** It declares a minimum provider version and configures no provider and
no backend.

## The design point

This module uses `google_project_iam_member` only. It never uses `google_project_iam_policy` or
`google_project_iam_binding`, both of which are **authoritative**: they remove any binding not
named in the configuration, including the ones Google's own service agents add automatically when
an API is enabled. An authoritative IAM resource inside a reusable module is a module that silently
deletes grants it cannot see (§26.29).

Roles are bound to **groups**, never to individual users — binding a role to a person is a finding
in this estate (§3.4).

**The module refuses to grant a basic role.** A validation rejects any role ID without a dot in it,
which is what Owner, Editor, Viewer, and Browser have in common and what every predefined and
custom role ID does not (`roles/compute.admin`, `projects/.../roles/rc.deployReleaser`). Testing
for the dot rejects all four without naming them, and rejects any future basic role for the same
reason (§3.10).

Bindings are flattened to one `google_project_iam_member` per role-principal pair, so adding a
principal to a role does not re-create the other principals' bindings.

## Usage

```hcl
module "project_iam" {
  source = "../../modules/project-iam"

  project_id = "rc-saas-prod-app-01"
  bindings = {
    "roles/run.invoker"    = ["group:gcp-app-developers@rickcollette.domain"]
    "roles/logging.viewer" = ["group:gcp-security-viewers@rickcollette.domain"]
  }
}
```
