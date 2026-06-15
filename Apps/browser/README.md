# Browser

Browser provides an OrbStack-friendly HTTPS service name for ephemeral remote Chromium sessions.

The actual session controller is deployed separately by `Apps/browser-jupyterhub` using the upstream JupyterHub Helm chart. This app exposes `browser.browser.svc.cluster.local` through a small nginx proxy that terminates a runtime-generated self-signed certificate and forwards requests to JupyterHub's `proxy-public` service.

## URLs

Cluster-internal and OrbStack host-accessible URL:

- `https://browser.browser.svc.cluster.local/`
- `https://browser.browser.svc.cluster.local/argocd`

HTTP redirects to HTTPS.

JupyterHub's native proxy service is reachable at:

- `http://proxy-public.browser-jupyterhub.svc.cluster.local/`

The spawned Chromium session opens Argo CD through cluster DNS:

- `https://argocd-server.argocd.svc.cluster.local/`

No externally reachable URL is configured.

## Session Behavior

- `/argocd` is an alias for the default Argo CD browser session.
- The spawned Chromium session runs in kiosk mode and pins Argo CD's internal TLS certificate by SPKI hash.
- Session behavior is configured in `Apps/browser-jupyterhub/values.yaml`.
- The browser proxy generates a self-signed TLS certificate at pod startup; no TLS private key is stored in Git.

## Verification Notes

Configuration has been prepared for OrbStack service-DNS access, but runtime HTTPS behavior must be verified after Argo CD sync.

Expected checks:

- `http://browser.browser.svc.cluster.local/argocd` redirects to HTTPS.
- `https://browser.browser.svc.cluster.local/argocd` redirects through temporary login/spawn and starts a Chromium pod.
- The spawned session reaches Argo CD at `https://argocd-server.argocd.svc.cluster.local/`.
- Inactive user pods are removed after the configured cull timeout.

## Repo Files

- `Apps/browser/app.yaml`
- `Apps/browser/Chart.yaml`
- `Apps/browser/values.yaml`
- `Apps/browser/templates/ConfigMap.yaml`
- `Apps/browser/templates/Deployment.yaml`
- `Apps/browser/templates/Service.yaml`
