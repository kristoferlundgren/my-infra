# Kyverno Policy Reporter

## Purpose

Kyverno Policy Reporter provides a web UI for viewing policy report results.

## Web UI

### Cluster-internal / OrbStack host-accessible

- `http://policy-reporter-ui.kyverno-policy-reporter.svc.cluster.local:8080`

### External

- None verified.

### Configured but currently unreachable externally

- `http://policy-reporter-ui.localhost/`
- `http://policy-reporter-ui.k8s.orb.local/`

## Verification

- Verified against the live cluster on 2026-05-31.
- `http://policy-reporter-ui.kyverno-policy-reporter.svc.cluster.local:8080` returned `200 OK`.
- The configured external hosts did not respond from the current machine during verification.

## Source

- `app.yaml`
- `values.yaml`
