#!/bin/sh -x

# Deploy Helm chart:
helm upgrade --install my-infra helmchart/ --take-ownership

# List installed Helm charts:
helm list -A --all
