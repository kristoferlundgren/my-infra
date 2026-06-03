#!/bin/sh -ex

cat bootstrap.yaml \
  | tee /dev/stdout \
  | kubectl apply -f -
