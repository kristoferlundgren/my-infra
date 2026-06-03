#!/bin/sh -ex

helm template . \
  | tee /dev/stdout \
  | kubectl apply -f -
