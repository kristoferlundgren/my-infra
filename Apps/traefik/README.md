# Traefik

## Purpose

Traefik provides the cluster ingress controller and an administrative dashboard.

## Web UI

### Cluster-internal / OrbStack host-accessible

- `http://traefik.traefik.svc.cluster.local/dashboard/`

### External

- None verified.

### Configured but currently unreachable externally

- `http://localhost/dashboard/`

## Verification

- Verified against the live cluster on 2026-05-31.
- `http://traefik.traefik.svc.cluster.local/dashboard/` returned `200 OK`.
- The live `IngressRoute` exposes the dashboard via `PathPrefix(`/dashboard`) || PathPrefix(`/api`)`.
- `http://localhost/dashboard/` did not respond from the current machine during verification.

## Source

- `app.yaml`
- `values.yaml`
