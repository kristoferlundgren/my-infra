#!/bin/bash -ex

# Show variables:
devbox secrets list --format dotenv | sed 's|=|: |'

# Deploy Helm chart:
helm template \
  my-infra helmchart/templpates/bootstrap/ \
  --take-ownership \
  --values helmchart/values.yaml \
  --values <(devbox secrets list --format dotenv --show | sed 's|=|: |')

# List installed Helm charts:
helm list -A --all
