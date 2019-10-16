#!/bin/bash

STACK=central
source ~/stackrc
time openstack overcloud deploy \
     --stack $STACK \
     --templates /usr/share/openstack-tripleo-heat-templates/ \
     -e /usr/share/openstack-tripleo-heat-templates/environments/disable-telemetry.yaml \
     -e /usr/share/openstack-tripleo-heat-templates/environments/low-memory-usage.yaml \
     -e /usr/share/openstack-tripleo-heat-templates/environments/enable-swap.yaml \
     -e /usr/share/openstack-tripleo-heat-templates/environments/podman.yaml \
     -e ~/containers-env-file.yaml \
     -e overrides.yaml
