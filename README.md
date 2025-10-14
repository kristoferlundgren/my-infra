# Helm chart managed by ArgoCD as Application

The Helm sub-chart in ./helmchart-bootstrap/ is deployed using kubectl. This creates an ArgoCD Application that deploys the Helm chart in ./helmchart/ and manages the Application itself as an app-of-apps.
