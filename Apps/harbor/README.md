# Harbor

## Purpose

Harbor provides the local container registry and web administration UI.

## Web UI

### Cluster-internal / OrbStack host-accessible

- `http://harbor.harbor.svc.cluster.local`

### External

- None verified.

## Verification

- Verified against the live cluster on 2026-05-31.
- `http://harbor.harbor.svc.cluster.local` returned `200 OK`.

## Source

- `app.yaml`
- `values.yaml`
