#!/bin/bash -ex

# Show variables:
devbox secrets list --format dotenv | sed 's|=|: |'

# Deploy Helm chart:
helm upgrade \
  --install my-infra helmchart/ \
  --take-ownership \
  --values helmchart/values.yaml \
  --values <(devbox secrets list --format dotenv --show | sed 's|=|: |')

# List installed Helm charts:
helm list -A --all
