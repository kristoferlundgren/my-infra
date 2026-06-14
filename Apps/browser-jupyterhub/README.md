# Browser JupyterHub

Browser JupyterHub deploys the upstream JupyterHub Helm chart as the session controller for ephemeral in-cluster Chromium sessions.

The user-facing alias lives in `Apps/browser` and points `http://browser.browser.svc.cluster.local/` at this app's `proxy-public` service.

## Runtime

- Chart: `jupyterhub` from `https://jupyterhub.github.io/helm-chart`
- Browser image: `lscr.io/linuxserver/chromium:latest`
- Authenticator: `jupyterhub-tmpauthenticator`
- Target URL opened in Chromium: `http://argocd-server.argocd.svc.cluster.local/`
- Idle cull timeout: 30 minutes
- User storage: disabled

## URLs

Cluster-internal and OrbStack host-accessible URL through the alias app:

- `http://browser.browser.svc.cluster.local/`

Native JupyterHub proxy service URL:

- `http://proxy-public.browser-jupyterhub.svc.cluster.local/`

No externally reachable URL is configured.

## Verification Notes

Configuration has been prepared for OrbStack service-DNS access, but runtime HTTP behavior must be verified after Argo CD sync.

Expected checks:

- `http://browser.browser.svc.cluster.local/` resolves to this app's `proxy-public` service.
- The JupyterHub endpoint redirects through temporary login/spawn and starts a Chromium pod.
- The spawned session reaches Argo CD at `http://argocd-server.argocd.svc.cluster.local/`.
- Inactive user pods are removed after the configured cull timeout.

## Repo Files

- `Apps/browser-jupyterhub/app.yaml`
- `Apps/browser-jupyterhub/values.yaml`
