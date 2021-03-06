#!/bin/bash
source ~/stackrc
time sudo openstack tripleo container image prepare \
  -e containers.yaml \
  --output-env-file ~/containers-env-file.yaml

curl -s http://192.168.24.1:8787/v2/_catalog | jq "."
