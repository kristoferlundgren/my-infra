#!/bin/sh -ex

helm template . | kubectl apply -f -
