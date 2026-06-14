# Browser

Browser provides an OrbStack-friendly service name for ephemeral remote Chromium sessions.

The actual session controller is deployed separately by `Apps/browser-jupyterhub` using the upstream JupyterHub Helm chart. This app only creates `browser.browser.svc.cluster.local` as an `ExternalName` alias to JupyterHub's `proxy-public` service.

## URLs

Cluster-internal and OrbStack host-accessible URL:

- `http://browser.browser.svc.cluster.local/`

JupyterHub's native proxy service is reachable at:

- `http://proxy-public.browser-jupyterhub.svc.cluster.local/`

The spawned Chromium session opens Argo CD through cluster DNS:

- `http://argocd-server.argocd.svc.cluster.local/`

No externally reachable URL is configured.

## Session Behavior

- Session behavior is configured in `Apps/browser-jupyterhub/values.yaml`.

## Verification Notes

Configuration has been prepared for OrbStack service-DNS access, but runtime HTTP behavior must be verified after Argo CD sync.

Expected checks:

- `http://browser.browser.svc.cluster.local/` resolves to `proxy-public.browser-jupyterhub.svc.cluster.local`.
- The JupyterHub endpoint redirects through temporary login/spawn and starts a Chromium pod.
- The spawned session reaches Argo CD at `http://argocd-server.argocd.svc.cluster.local/`.
- Inactive user pods are removed after the configured cull timeout.

## Repo Files

- `Apps/browser/app.yaml`
- `Apps/browser/Chart.yaml`
- `Apps/browser/values.yaml`
- `Apps/browser/templates/Service.yaml`
