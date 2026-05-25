# Helm chart managed by ArgoCD as Application

The Helm sub-chart in ./helmchart-bootstrap/ is deployed using kubectl. This creates an ArgoCD Application that deploys the Helm chart in ./helmchart/ and manages the Application itself as an app-of-apps.

## Local OCI registry

The local registry is deployed by the `harbor` ArgoCD Application in `./helmchart/templates/harbor.yaml`.

### Harbor UI login

Use the admin credentials from the live Harbor secret in Kubernetes:

- username: `admin`
- password: `kubectl -n harbor get secret harbor-core -o jsonpath='{.data.HARBOR_ADMIN_PASSWORD}' | base64 --decode`

To log in from the repo, use the Harbor host from `./helmchart/templates/harbor.yaml`:

```bash
docker login harbor-core.k8s.orb.local -u admin
```

Enter the password from `secret/harbor-core` when prompted.

Web UI: `http://harbor-portal.harbor.svc.cluster.local/`

The browser login form posts to `/c/login` on the same Harbor host, so the UI must be reached through a host that routes that path to Harbor.

Verification: the current cluster accepts the same credentials at `http://127.0.0.1:8080/api/v2.0/users/current` when queried from the `harbor-core` pod.

Use `scripts/mirror-local-oci-registry.sh` to populate it with the chart and image inventory required by the project.

Useful checks:

- `scripts/mirror-local-oci-registry.sh --list` prints both inventories.
- `OCI_REGISTRY=<registry> OCI_PROJECT=<project> scripts/mirror-local-oci-registry.sh --dry-run` prints every `helm pull`, `helm push`, and `skopeo copy` command without touching the registry.
- Once Harbor is up, run the wrapper without `--dry-run` to push the mirrored Helm charts and images.

## Helm chart mirroring

The mirroring pipeline lives in `scripts/mirror-helm-charts.sh` and uses the shared source inventory in `scripts/helm-chart-inventory.sh`.

Run it with `OCI_REGISTRY` and `OCI_PROJECT` set, or use `--dry-run` to print the source-to-target mapping without pushing anything.

Useful checks:

- `scripts/mirror-helm-charts.sh --list` prints the chart inventory.
- `OCI_REGISTRY=<registry> OCI_PROJECT=<project> scripts/mirror-helm-charts.sh --dry-run` prints the `helm pull` and `helm push` commands without touching the registry.
- Mirrored charts are pushed to `oci://${OCI_REGISTRY}/${OCI_PROJECT}/helm/<chart>`.

## Non-Helm image mirroring

The non-Helm image pipeline lives in `scripts/mirror-non-helm-images.sh` and uses `scripts/non-helm-image-inventory.sh`.

It mirrors images into `docker://${OCI_REGISTRY}/${OCI_PROJECT}/<source path>:<tag>` so the registry layout stays aligned with the source repository path.

Useful checks:

- `scripts/mirror-non-helm-images.sh --list` prints the source image inventory.
- `OCI_REGISTRY=<registry> OCI_PROJECT=<project> scripts/mirror-non-helm-images.sh --dry-run` prints the `skopeo copy` commands without copying anything.
- Mirrored images keep the original tag and land under `docker://${OCI_REGISTRY}/${OCI_PROJECT}/<source path>:<tag>`.
