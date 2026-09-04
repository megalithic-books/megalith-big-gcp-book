#!/usr/bin/env bash
# Read back the organization policy baseline and report what is ACTUALLY in
# effect, rather than what was declared.
#
# The distinction matters: a constraint set at the organization and overridden
# at a folder still reads as enforced at the root. Only --effective at the
# resource answers the real question, and evidence has to come from that rather
# than from the definition (31.1, 29.11).
#
#   ./verify-baseline.sh 123456789012
#   ./verify-baseline.sh 123456789012 --project rc-saas-prod-app-01
set -euo pipefail

ORG_ID="${1:?usage: verify-baseline.sh ORG_ID [--project PROJECT_ID]}"
shift || true
SCOPE=(--organization="$ORG_ID")
LABEL="organization $ORG_ID"
if [[ "${1:-}" == "--project" ]]; then
  SCOPE=(--project="${2:?--project needs a value}")
  LABEL="project ${2}"
fi

# The four that belong in every baseline and are NOT applied for you, even on an
# organization created after 2024-05-03 (31.1).
CONSTRAINTS=(
  compute.requireOsLogin
  compute.requireShieldedVm
  compute.disableSerialPortAccess
  compute.skipDefaultNetworkCreation
)

printf 'Effective organization policy at %s\n\n' "$LABEL"
fail=0
for c in "${CONSTRAINTS[@]}"; do
  # --effective resolves the whole ancestry. Without it this reports only what
  # is set at this node, which is the wrong question.
  if out=$(gcloud org-policies describe "$c" "${SCOPE[@]}" --effective --format='value(spec.rules[0].enforce)' 2>/dev/null); then
    if [[ "$out" == "True" ]]; then
      printf '  ENFORCED     constraints/%s\n' "$c"
    else
      printf '  NOT ENFORCED constraints/%s\n' "$c"; fail=1
    fi
  else
    printf '  UNSET        constraints/%s\n' "$c"; fail=1
  fi
done

printf '\n'
if (( fail )); then
  printf 'At least one baseline constraint is not in effect. See 31.1.\n' >&2
  exit 1
fi
printf 'All four baseline constraints are in effect.\n'
