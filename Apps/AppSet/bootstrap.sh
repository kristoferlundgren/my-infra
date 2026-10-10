#!/bin/sh -ex

cat bootstrap.yaml
kubectl apply --server-side -f dependencies/Namespace.yaml
kubectl apply --server-side -f dependencies/AppProject.yaml
kubectl apply --server-side -f bootstrap.yaml
