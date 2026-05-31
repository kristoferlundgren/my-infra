# Grafana Test

## Purpose

This app provides a test Grafana instance managed by the Grafana Operator.

## Web UI

### Cluster-internal / OrbStack host-accessible

- `http://grafana-test-service.grafana-test.svc.cluster.local:3000`

### External

- None verified.

## Verification

- Verified against the live cluster on 2026-05-31.
- `http://grafana-test-service.grafana-test.svc.cluster.local:3000` returned a redirect to `/login`.

## Source

- `app.yaml`
- `templates/grafana-test.yaml`
- `values.yaml`
