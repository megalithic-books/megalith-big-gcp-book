# network

Shared VPC host network for one environment: the VPC, its regional subnets, the GKE secondary
ranges, and flow logs. Introduced in §5.28 and used as the module-design worked example in §26.28.

**This is a child module.** It declares a minimum provider version and configures no provider and
no backend — the root module owns both (§26.5).

## The design point

The CIDR plan is an **input**, not a computed value. A module that allocates its own ranges cannot
be used twice in the same estate without collision, and the allocation is exactly the decision a
network team needs to hold (§5.6). Pass `subnets` explicitly.

## Inputs

| Variable | Type | Notes |
|---|---|---|
| `project_id` | `string` | Host project that owns the VPC. No default — callers must be explicit. |
| `name_prefix` | `string` | Prefix for every resource name, e.g. `rc-saas-prod`. |
| `subnets` | `map(object)` | `region`, `primary_range`, optional `secondary_ranges` and `flow_log_sampling` (default `0.5`). |
| `enable_apis` | `bool` | Default `true`. `disable_on_destroy` is `false`, so destroying one instance cannot disable an API another still needs. |

Outputs: `network_id`, `network_self_link`, `subnet_ids`, `subnet_secondary_ranges`.

## Usage

Ranges below are the SaaS reference plan from §5.6. Substitute your own.

```hcl
module "network" {
  source = "../../modules/network"

  project_id  = "rc-saas-shared-net-01"
  name_prefix = "rc-saas-prod"

  subnets = {
    "usc1-app" = {
      region        = "us-central1"
      primary_range = "10.128.0.0/20"
      secondary_ranges = {
        pods     = "10.144.0.0/14"
        services = "10.148.0.0/20"
      }
      flow_log_sampling = 1.0
    }
    "euw1-app" = {
      region        = "europe-west1"
      primary_range = "10.129.0.0/20"
    }
  }
}
```

The VPC is created with `network_firewall_policy_enforcement_order = "BEFORE_CLASSIC_FIREWALL"`,
which is this book's default: it evaluates Cloud NGFW policies **before** any legacy VPC rule left
in a project, rather than after (§5.14). Private Google Access is on for every subnet (§5.17).

Flow logs are on by default at 0.5 sampling. They cost money and they are the only record of what
actually talked to what (§5.4); turn them down with sampling rather than off.
