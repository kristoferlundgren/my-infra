# OpenBao

## Purpose

OpenBao provides a secrets management UI.

## Web UI

### Cluster-internal / OrbStack host-accessible

- `http://openbao.openbao.svc.cluster.local:8200/ui/`

### External

- None verified.

## Verification

- Verified against the live cluster on 2026-05-31.
- `http://openbao.openbao.svc.cluster.local:8200/ui/` returned `200 OK`.

## Source

- `app.yaml`
- `values.yaml`
