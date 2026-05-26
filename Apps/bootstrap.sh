#!/bin/sh -ex

helm template ./AppSet \
  | tee /dev/stdout \
  | kubectl apply -f -
