# AGENTS

## Purpose

This repository is a Git-managed source of truth for Kubernetes platform applications deployed with Argo CD.

- Active infrastructure application configuration lives under `Apps/`.
- App changes should be made in Git and reconciled by Argo CD.
- This repo is for maintaining application definitions, Helm values, and related operational documentation.

## Repository Layout

- `Apps/<app>/app.yaml`: Argo CD application source definition.
- `Apps/<app>/values.yaml`: Helm chart overrides for the app.
- `Apps/<app>/templates/`: Templates for apps rendered from local charts in this repo.
- `Apps/AppSet/`: Bootstrap app-of-apps resources.
- `Apps/bootstrap.sh`: Bootstrap render-and-apply helper.

## How To Maintain Code And Config

- Prefer small, app-local changes.
- Keep each app's configuration inside its own directory unless the change is intentionally cross-cutting.
- Update `targetRevision`, `values.yaml`, and local templates consistently when changing an app version or behavior.
- Preserve Argo CD sync ordering unless a rollout dependency is intentionally being changed.
- Treat live cluster inspection as verification, not as the source of truth. Persist intended state in Git.
- Do not document behavior that is not represented in the current repo or verified in the live cluster.

## How To Maintain Documentation

- Keep repo-level guidance in the root `README.md` and this `AGENTS.md`.
- Keep app-local operational details in the nearest app directory `README.md`.
- Update docs in the same change as code/config when the behavior being documented changes.
- Prefer exact URLs and paths over general descriptions.
- Do not store credentials in documentation. If login details are needed, point to the relevant Kubernetes secret or retrieval command instead of copying secret values.

## README.md Maintenance Rules

- Add a `README.md` to every app directory that has a verified usable web UI.
- Keep one README per deployable app directory.
- If one app exposes multiple related UIs, document them in the same README.
- Each UI README should include a short purpose statement.
- Each UI README should include cluster-internal / OrbStack host-accessible URL values.
- Each UI README should include externally reachable URL values, if verified.
- Each UI README should include configured but currently unreachable external URLs, if present.
- Each UI README should include short verification notes.
- Each UI README should include the repo files that define the deployment.
- When an app's namespace, service name, ingress host, route rule, or UI base path changes, update its README in the same change.
- If a documented URL stops working, either correct the documentation or remove the stale claim.

## Web UI Verification Rules

- Verify both config and runtime before documenting a UI.
- Acceptable verification includes ingress, route, or service objects that exist in the cluster.
- Acceptable verification includes HTTP `200 OK`.
- Acceptable verification includes an expected redirect to a login page or canonical UI path.
- Document the exact base path when required, for example `/dashboard/`, `/dex`, `/ui/`, or `/select/vmui/`.
- Keep externally reachable URLs separate from cluster-internal URLs when they are not the same.
