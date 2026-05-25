#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/non-helm-image-inventory.sh
source "$script_dir/non-helm-image-inventory.sh"

usage() {
  cat <<'EOF'
Usage: mirror-non-helm-images.sh [--dry-run] [--list]

Environment:
  OCI_REGISTRY   Destination registry host, for example harbor-core.k8s.orb.local
  OCI_PROJECT    Destination project path, for example my-infra
  OCI_USERNAME   Optional registry username for the destination login
  OCI_PASSWORD   Optional registry password for the destination login
EOF
}

dry_run=0
list_only=0
policy_file="$(mktemp)"
runtime_home=""

cleanup() {
  rm -f "$policy_file"
  if [[ -n "$runtime_home" ]]; then
    rm -rf "$runtime_home"
  fi
}

trap cleanup EXIT

cat >"$policy_file" <<'EOF'
{
  "default": [
    {
      "type": "insecureAcceptAnything"
    }
  ]
}
EOF

if [[ "${OCI_PLAIN_HTTP:-0}" -eq 1 ]]; then
  runtime_home="$(mktemp -d)"
  mkdir -p "$runtime_home/.config/containers"
  cat >"$runtime_home/.config/containers/registries.conf" <<EOF
[[registry]]
location = "${OCI_REGISTRY:?Set OCI_REGISTRY before mirroring images.}"
insecure = true
EOF
fi

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
  printf 'source\ttarget_repository\n'
  for entry in "${NON_HELM_IMAGE_SOURCES[@]}"; do
    IFS='|' read -r source_ref target_repo <<<"$entry"
    printf '%s\t%s\n' "$source_ref" "$target_repo"
  done
  exit 0
fi

: "${OCI_REGISTRY:?Set OCI_REGISTRY before mirroring images.}"
: "${OCI_PROJECT:?Set OCI_PROJECT before mirroring images.}"

if [[ -n "${OCI_USERNAME:-}" && -n "${OCI_PASSWORD:-}" && "${OCI_PLAIN_HTTP:-0}" -ne 1 ]]; then
  printf '%s' "$OCI_PASSWORD" | skopeo login "$OCI_REGISTRY" --username "$OCI_USERNAME" --password-stdin
fi

mirror_image() {
  local source_ref="$1"
  local target_repo="$2"
  local source_tag target_ref

  source_tag="${source_ref##*:}"
  target_ref="docker://${OCI_REGISTRY}/${OCI_PROJECT}/${target_repo}:${source_tag}"

  if [[ "$dry_run" -eq 1 ]]; then
    printf 'skopeo copy docker://%s %s\n' "$source_ref" "$target_ref"
    return
  fi

  printf 'Mirroring %s -> %s\n' "$source_ref" "$target_ref"
  if [[ "${OCI_PLAIN_HTTP:-0}" -eq 1 ]]; then
    if [[ -n "${OCI_USERNAME:-}" && -n "${OCI_PASSWORD:-}" ]]; then
      HOME="$runtime_home" skopeo copy --policy "$policy_file" --dest-tls-verify=false --dest-creds "$OCI_USERNAME:$OCI_PASSWORD" --multi-arch all "docker://${source_ref}" "$target_ref"
    else
      HOME="$runtime_home" skopeo copy --policy "$policy_file" --dest-tls-verify=false --dest-no-creds --multi-arch all "docker://${source_ref}" "$target_ref"
    fi
  else
    skopeo copy --policy "$policy_file" --multi-arch all "docker://${source_ref}" "$target_ref"
  fi
}

for entry in "${NON_HELM_IMAGE_SOURCES[@]}"; do
  IFS='|' read -r source_ref target_repo <<<"$entry"
  mirror_image "$source_ref" "$target_repo"
done
