#!/bin/sh -ex

helm template ./AppSet \
  | tee tee /dev/stdout \
  | kubectl apply -f -
