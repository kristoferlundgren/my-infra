# kube-prometheus-stack

## Purpose

This app provides the monitoring stack, including Grafana, Prometheus, and Alertmanager web UIs.

## Web UIs

### Cluster-internal / OrbStack host-accessible

- Grafana: `http://kube-prometheus-stack-grafana.kube-prometheus-stack.svc.cluster.local/login`
- Prometheus: `http://kube-prometheus-stack-prometheus.kube-prometheus-stack.svc.cluster.local:9090`
- Alertmanager: `http://kube-prometheus-stack-alertmanager.kube-prometheus-stack.svc.cluster.local:9093`

### External

- None verified.

### Configured but currently unreachable externally

- None. Ingress is disabled for Grafana, Prometheus, and Alertmanager in the current values.

## Verification

- Verified against the live cluster on 2026-05-31.
- Grafana login URL returned `200 OK`.
- Prometheus returned a redirect to `/query`.
- Alertmanager returned `200 OK`.

## Source

- `app.yaml`
- `values.yaml`
