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

See `variables.tf`. Every subnet carries `name`, `region`, `cidr`, and optional secondary ranges
for GKE pods and services.

## Usage

```hcl
module "network" {
  source = "../../modules/network"

  project_id  = var.host_project_id
  network_name = "vpc-prod-global"
  subnets     = var.subnets
}
```

Flow logs are on by default. They cost money and they are the only record of what actually talked
to what (§5.33); turn them down with sampling rather than off.
