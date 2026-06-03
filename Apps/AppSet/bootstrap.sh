#!/bin/sh -ex

cat bootstrap.yaml
kubectl apply -f dependencies/Namespace.yaml
kubectl apply -f dependencies/AppProject.yaml
kubectl apply -f bootstrap.yaml
