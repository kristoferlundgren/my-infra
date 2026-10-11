# Zitadel sealed secrets

`seal.sh` reads credentials from the process environment and writes three
strictly scoped SealedSecret manifests into this Helm chart's `templates/`
directory. The plaintext input is streamed to `kubeseal`; it is not written to
the repository or to a temporary file.

Required environment variables:

| Variable | Secret key |
| --- | --- |
| `ZITADEL_POSTGRES_PASSWORD` | `zitadel-postgres-auth/password` |
| `ZITADEL_POSTGRES_ADMIN_PASSWORD` | `zitadel-postgres-auth/postgres-password` |
| `ZITADEL_MASTERKEY` | `zitadel-masterkey/masterkey` |
| `ZITADEL_TERRAFORM_ACCESS_TOKEN` | `zitadel-terraform-auth/access-token` |

`ZITADEL_MASTERKEY` must be exactly 32 bytes and must remain unchanged
while the Zitadel data it encrypts is retained. Install `kubeseal` and make the
Sealed Secrets controller's public certificate available: by default,
`kubeseal` fetches it from the cluster; set `SEALED_SECRETS_CERT` to use a local
certificate file instead. The controller name and namespace default to
`sealed-secrets` and can be overridden with
`SEALED_SECRETS_CONTROLLER_NAME` and `SEALED_SECRETS_CONTROLLER_NAMESPACE`.

Load the four variables from your secret manager into the environment, then
run:

```sh
./Apps/zitadel/secrets/seal.sh
```

Review and commit the generated `*.sealedsecret.yaml` files. Argo CD then
reconciles the SealedSecrets, and the controller creates the corresponding
Kubernetes Secrets in the `zitadel` namespace. Do not commit the input values.
