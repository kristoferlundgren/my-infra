#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

usage() {
  cat <<'EOF'
Usage: mirror-local-oci-registry.sh [--dry-run] [--list]

Environment:
  OCI_REGISTRY   Destination registry host, for example harbor-core.k8s.orb.local
  OCI_PROJECT    Destination project path, for example my-infra
  OCI_USERNAME   Optional registry username for the destination login
  OCI_PASSWORD   Optional registry password for the destination login
EOF
}

dry_run=0
list_only=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run)
      dry_run=1
      ;;
    --list)
      list_only=1
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      printf 'Unknown argument: %s\n' "$1" >&2
      usage >&2
      exit 1
      ;;
  esac
  shift
done

if [[ "$list_only" -eq 1 ]]; then
  printf '## Helm charts\n'
  "$script_dir/mirror-helm-charts.sh" --list
  printf '\n## Container images\n'
  "$script_dir/mirror-non-helm-images.sh" --list
  exit 0
fi

if [[ "$dry_run" -eq 1 ]]; then
  "$script_dir/mirror-helm-charts.sh" --dry-run
  printf '\n'
  "$script_dir/mirror-non-helm-images.sh" --dry-run
  exit 0
fi

"$script_dir/mirror-helm-charts.sh"
"$script_dir/mirror-non-helm-images.sh"
