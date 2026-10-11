#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
templates_dir="${script_dir}/templates"
tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT
umask 077

required_env=(
  ZITADEL_POSTGRES_PASSWORD
  ZITADEL_POSTGRES_ADMIN_PASSWORD
  ZITADEL_MASTERKEY
  ZITADEL_TERRAFORM_ACCESS_TOKEN
)
for name in "${required_env[@]}"; do
  if [[ -z "${!name:-}" ]]; then
    printf 'Required environment variable is unset or empty: %s\n' "$name" >&2
    exit 1
  fi
done

if ! python3 -c 'import os, sys; sys.exit(len(os.environ["ZITADEL_MASTERKEY"].encode("utf-8")) != 32)'; then
  printf 'ZITADEL_MASTERKEY must be exactly 32 bytes.\n' >&2
  exit 1
fi

seal_secret() {
  local secret_name="$1"
  shift
  local -a seal_args=(
    --format yaml
    --scope strict
    --controller-name "${SEALED_SECRETS_CONTROLLER_NAME:-sealed-secrets}"
    --controller-namespace "${SEALED_SECRETS_CONTROLLER_NAMESPACE:-sealed-secrets}"
  )
  if [[ -n "${SEALED_SECRETS_CERT:-}" ]]; then
    seal_args+=(--cert "$SEALED_SECRETS_CERT")
  fi

  python3 - "$secret_name" "$@" <<'PY' | kubeseal "${seal_args[@]}" > "${tmp_dir}/${secret_name}.yaml"
import base64
import os
import sys

secret_name, *pairs = sys.argv[1:]
if len(pairs) % 2:
    raise SystemExit("Expected key/environment-variable pairs")

print("apiVersion: v1")
print("kind: Secret")
print("metadata:")
print(f"  name: {secret_name}")
print("  namespace: zitadel")
print("type: Opaque")
print("data:")
for key, env_name in zip(pairs[::2], pairs[1::2]):
    value = os.environ[env_name].encode("utf-8")
    encoded = base64.b64encode(value).decode("ascii")
    print(f"  {key}: {encoded}")
PY
}

seal_secret zitadel-postgres-auth \
  password ZITADEL_POSTGRES_PASSWORD \
  postgres-password ZITADEL_POSTGRES_ADMIN_PASSWORD
seal_secret zitadel-masterkey masterkey ZITADEL_MASTERKEY
seal_secret zitadel-terraform-auth access-token ZITADEL_TERRAFORM_ACCESS_TOKEN

mv "${tmp_dir}/zitadel-postgres-auth.yaml" "${templates_dir}/zitadel-postgres-auth.sealedsecret.yaml"
mv "${tmp_dir}/zitadel-masterkey.yaml" "${templates_dir}/zitadel-masterkey.sealedsecret.yaml"
mv "${tmp_dir}/zitadel-terraform-auth.yaml" "${templates_dir}/zitadel-terraform-auth.sealedsecret.yaml"

printf 'Wrote SealedSecret manifests under %s\n' "$templates_dir"
