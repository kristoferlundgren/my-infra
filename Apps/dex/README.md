# Dex

## Purpose

Dex provides an OIDC identity provider web UI and endpoints.

## Web UI

### Cluster-internal / OrbStack host-accessible

- `http://dex.dex.svc.cluster.local:5556/dex`

### External

- None verified.

### Configured but currently unreachable externally

- `http://dex.localhost/dex`

## Verification

- Verified against the live cluster on 2026-05-31.
- `http://dex.dex.svc.cluster.local:5556/dex` returned `200 OK`.
- `http://dex.localhost/dex` did not respond from the current machine during verification.

## Source

- `app.yaml`
- `values.yaml`
