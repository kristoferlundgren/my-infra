#!/bin/bash -ex

# Show variables:
devbox secrets list --format dotenv | sed 's|=|: |'

echo Deploying Bootstrap Helm chart...
helm template \
  my-infra helmchart-bootstrap \
  --take-ownership \
  --values helmchart/values.yaml \
  --values <(devbox secrets list --format dotenv --show | sed 's|=|: |') \
  | kubectl apply --filename -
