# Zitadel Terraform job

This chart applies a Terraform configuration that creates a Headlamp project and
Web OIDC application in the default Zitadel organization. It then creates the
`oidc` Secret in the `headlamp` namespace for the Headlamp chart to consume.

## Prerequisite

Create a Zitadel machine user/PAT with IAM owner permissions, then set
`ZITADEL_TERRAFORM_ACCESS_TOKEN` in the environment used to run
`Apps/zitadel/secrets/seal.sh`. That process creates the
`zitadel-terraform-auth` Secret manifest alongside the Postgres and master key
SealedSecrets. Keep the PAT out of Git. The job will not complete until this
Secret exists and the PAT can create projects and OIDC applications.

## Redirect URL assumption

The configured callback is `http://headlamp.localhost/oidc-callback` and the
post-logout URL is `http://headlamp.localhost/`, matching the repo's current
`.localhost` development ingress setup. Change these values in `values.yaml` if
the Headlamp hostname or scheme differs. Zitadel's issuer URL is configured as
`http://zitadel.localhost`.

## Terraform state

The job keeps local Terraform state on the `zitadel-terraform-state` PVC so
subsequent syncs update the same project and application. Terraform state
contains the generated OIDC client secret. Protect the PVC and its backing
storage accordingly; use an encrypted remote backend if one is available.
