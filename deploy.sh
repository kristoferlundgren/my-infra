#!/bin/sh -x

# Deploy Helm chart:
helm upgrade \
  --install my-infra helmchart/ \
  --take-ownership \
  --values <(devbox secrets list --format dotenv --show)

# List installed Helm charts:
helm list -A --all
