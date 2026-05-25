#!/usr/bin/env bash

# Shared source inventory for the Helm chart mirroring pipeline.
# Format: repository URL | chart name | version
HELM_CHART_SOURCES=(
  "https://kyverno.github.io/kyverno|kyverno|3.7.1"
  "https://kyverno.github.io/kyverno|kyverno-policies|3.7.1"
  "https://kyverno.github.io/policy-reporter|policy-reporter|3.7.3"
  "https://victoriametrics.github.io/helm-charts/|victoria-metrics-operator|0.57.1"
  "https://traefik.github.io/charts|traefik|37.4.0"
  "https://charts.dexidp.io|dex|0.24.0"
  "https://openbao.github.io/openbao-helm|openbao|0.19.3"
  "https://kubernetes.github.io/ingress-nginx|ingress-nginx|4.13.3"
  "https://helm.goharbor.io|harbor|1.18.0"
  "https://metallb.github.io/metallb|metallb|0.15.2"
  "https://prometheus-community.github.io/helm-charts|kube-prometheus-stack|78.2.1"
  "https://open-telemetry.github.io/opentelemetry-helm-charts|opentelemetry-collector|0.133.0"
  "https://bitnami-labs.github.io/sealed-secrets/|sealed-secrets|2.17.4"
  "https://aquasecurity.github.io/helm-charts/|trivy-operator|0.31.0"
  "https://stakater.github.io/stakater-charts|reloader|2.2.2"
  "https://open-telemetry.github.io/opentelemetry-helm-charts|opentelemetry-operator|0.95.0"
  "oci://ghcr.io/grafana/helm-charts/grafana-operator|grafana-operator|v5.19.4"
  "https://charts.jetstack.io|cert-manager|v1.19.0"
  "oci://ghcr.io/spegel-org/helm-charts/spegel|spegel|0.3.0"
  "https://helm.coder.com/v2|coder|2.32.0"
  "https://traefik.github.io/charts|traefik|37.1.2"
)
