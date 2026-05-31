#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/helm-chart-inventory.sh
source "$script_dir/helm-chart-inventory.sh"

usage() {
  cat <<'EOF'
Usage: mirror-helm-charts.sh [--dry-run] [--list]

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
  printf 'repository\tchart\tversion\n'
  for entry in "${HELM_CHART_SOURCES[@]}"; do
    IFS='|' read -r repository chart version <<<"$entry"
    printf '%s\t%s\t%s\n' "$repository" "$chart" "$version"
  done
  exit 0
fi

: "${OCI_REGISTRY:?Set OCI_REGISTRY before mirroring charts.}"
: "${OCI_PROJECT:?Set OCI_PROJECT before mirroring charts.}"

if [[ -n "${OCI_USERNAME:-}" && -n "${OCI_PASSWORD:-}" ]]; then
  if [[ "${OCI_PLAIN_HTTP:-0}" -eq 1 ]]; then
    printf '%s' "$OCI_PASSWORD" | helm registry login "$OCI_REGISTRY" --username "$OCI_USERNAME" --password-stdin --plain-http
  else
    printf '%s' "$OCI_PASSWORD" | helm registry login "$OCI_REGISTRY" --username "$OCI_USERNAME" --password-stdin
  fi
fi

mirror_chart() {
  local repository="$1"
  local chart="$2"
  local version="$3"
  local source_ref target_ref temp_dir archive

  if [[ "$repository" == oci://* ]]; then
    source_ref="$repository"
  else
    source_ref="${repository%/}"
  fi

  target_ref="oci://${OCI_REGISTRY}/${OCI_PROJECT}/helm"

  if [[ "$dry_run" -eq 1 ]]; then
    printf 'helm pull %s --version %s --destination <temp>\n' "$source_ref" "$version"
    printf 'helm push <temp>/%s-%s.tgz %s\n' "$chart" "$version" "$target_ref"
    return
  fi

  temp_dir="$(mktemp -d)"

  printf 'Mirroring %s %s -> %s\n' "$chart" "$version" "$target_ref"
  if [[ "$repository" == oci://* ]]; then
    helm pull "$source_ref" --version "$version" --destination "$temp_dir"
  else
    helm pull --repo "$source_ref" "$chart" --version "$version" --destination "$temp_dir"
  fi
  shopt -s nullglob
  local archives=("$temp_dir"/*.tgz)
  shopt -u nullglob
  if [[ "${#archives[@]}" -ne 1 ]]; then
    printf 'Expected exactly one Helm archive in %s, found %s\n' "$temp_dir" "${#archives[@]}" >&2
    rm -rf "$temp_dir"
    return 1
  fi
  archive="${archives[0]}"
  if [[ "${OCI_PLAIN_HTTP:-0}" -eq 1 ]]; then
    helm push "$archive" "$target_ref" --plain-http
  else
    helm push "$archive" "$target_ref"
  fi
  rm -rf "$temp_dir"
}

for entry in "${HELM_CHART_SOURCES[@]}"; do
  IFS='|' read -r repository chart version <<<"$entry"
  mirror_chart "$repository" "$chart" "$version"
done
