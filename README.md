# my-infra

This repository manages Kubernetes infrastructure applications with Argo CD.

## Purpose

- `Apps/` is the active source of truth for cluster applications.
- Each application is maintained as a small app directory with Argo CD source configuration and optional Helm values or local templates.
- The repository is intended to be updated declaratively through Git rather than by manual in-cluster edits.

## Layout

- `Apps/<app>/app.yaml`: Argo CD application source definition.
- `Apps/<app>/values.yaml`: Helm value overrides for the app.
- `Apps/<app>/templates/`: Local chart templates when the app is rendered from this repo.
- `Apps/AppSet/`: Bootstrap and app-of-apps resources.
- `Apps/bootstrap.sh`: Renders and applies the bootstrap app set.

## Tooling

The repo includes a `devbox.json` with the main tools used to maintain the cluster configuration:

- `helm`
- `kubectl`
- `kubectx`
- `argocd`
- `kyverno`

## Documentation Policy

- Keep repo-level guidance in the root `README.md` and `AGENTS.md`.
- Keep app-specific operational notes in the nearest app directory.
- Every app directory with a verified usable web UI should have a `README.md` documenting that UI.
- Web UI documentation should distinguish between cluster-internal / OrbStack host-accessible URLs, externally reachable URLs, and configured but currently unreachable external URLs.
- When a change modifies an app's namespace, service name, ingress host, route, or UI base path, update its `README.md` in the same change.

## Web UI READMEs

The following app directories currently include UI documentation:

- `Apps/coder/`
- `Apps/dex/`
- `Apps/grafana/grafana-test/`
- `Apps/harbor/`
- `Apps/kube-prometheus-stack/`
- `Apps/kyverno-policy-reporter/`
- `Apps/openbao/`
- `Apps/traefik/`
- `Apps/victorialogs/`
