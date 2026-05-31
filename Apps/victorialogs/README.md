# VictoriaLogs

## Purpose

VictoriaLogs provides log storage and a built-in web UI for log exploration.

## Web UI

### Cluster-internal / OrbStack host-accessible

- `http://vlselect-my-victorialogs.victorialogs.svc.cluster.local:9471/select/vmui/`
- `http://vlclusterlb-my-victorialogs.victorialogs.svc.cluster.local:8427/select/vmui/`

### External

- None verified.

## Verification

- Verified against the live cluster on 2026-05-31.
- Both `/select/vmui/` URLs returned `200 OK`.
- Upstream VictoriaLogs documentation identifies `/select/vmui/` as the built-in web UI path.

## Source

- `app.yaml`
- `Chart.yaml`
- `templates/VLCluster.yaml`
- `values.yaml`
