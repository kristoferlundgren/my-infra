#!/bin/sh -ex

helm template ./Apps \
  | tee tee /dev/stdout \
  | kubectl apply -f -
