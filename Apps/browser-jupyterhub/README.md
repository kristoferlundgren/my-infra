# Browser JupyterHub

Browser JupyterHub deploys the upstream JupyterHub Helm chart as the session controller for ephemeral in-cluster Chromium sessions.

The user-facing alias lives in `Apps/browser` and exposes a landing page at `https://browser.browser.svc.cluster.local/` that redirects endpoint requests to this app's JupyterHub service.

## Runtime

- Chart: `jupyterhub` from `https://jupyterhub.github.io/helm-chart`
- Browser image: `lscr.io/linuxserver/chromium:latest`
- Authenticator: `jupyterhub-tmpauthenticator`
- Browser targets:
- `argocd`: `https://argocd-server.argocd.svc.cluster.local/`
- `headlamp`: `http://headlamp.headlamp.svc.cluster.local/`
- Chromium launch mode: kiosk. Argo CD sessions pin Argo CD's internal TLS certificate by SPKI hash.
- Idle cull timeout: 30 minutes
- User storage: disabled
- Named servers: enabled; every endpoint request creates a new randomly named server and pod.

## URLs

Cluster-internal and OrbStack host-accessible URL through the alias app:

- `https://browser.browser.svc.cluster.local/`
- `https://browser.browser.svc.cluster.local/argocd`
- `https://browser.browser.svc.cluster.local/headlamp`

HTTP redirects to HTTPS through the alias app.

Native JupyterHub proxy service URL:

- `http://proxy-public.browser-jupyterhub.svc.cluster.local/`

No externally reachable URL is configured.

## Verification Notes

Configuration has been prepared for OrbStack service-DNS access.

Expected checks:

- `https://browser.browser.svc.cluster.local/` returns the landing page without spawning a pod.
- `https://browser.browser.svc.cluster.local/argocd` redirects through temporary login/spawn and starts a new Chromium pod.
- Repeating `/argocd` starts another Chromium pod rather than reusing the first.
- `https://browser.browser.svc.cluster.local/headlamp` starts a Headlamp Chromium pod.
- The spawned session reaches Argo CD at `https://argocd-server.argocd.svc.cluster.local/`.
- Inactive user pods are removed after the configured cull timeout.

## Repo Files

- `Apps/browser-jupyterhub/app.yaml`
- `Apps/browser-jupyterhub/values.yaml`
