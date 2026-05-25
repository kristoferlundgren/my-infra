#!/usr/bin/env bash

# Shared source inventory for the non-Helm container image mirroring pipeline.
# Format: source image reference | target repository path
NON_HELM_IMAGE_SOURCES=(
  "ghcr.io/open-telemetry/opentelemetry-collector-releases/opentelemetry-collector-k8s:0.133.0|open-telemetry/opentelemetry-collector-releases/opentelemetry-collector-k8s"
  "wbitt/network-multitool:latest|wbitt/network-multitool"
)
