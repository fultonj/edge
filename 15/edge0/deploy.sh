#!/bin/bash
STACK=edge0
source ~/stackrc
if [[ ! -e distributed_compute_hci.yaml ]]; then
    openstack overcloud roles generate DistributedComputeHCI -o distributed_compute_hci.yaml
fi
time openstack overcloud deploy \
     --stack $STACK \
     --templates /usr/share/openstack-tripleo-heat-templates/ \
     -r distributed_compute_hci.yaml \
     -e /usr/share/openstack-tripleo-heat-templates/environments/disable-telemetry.yaml \
     -e /usr/share/openstack-tripleo-heat-templates/environments/low-memory-usage.yaml \
     -e /usr/share/openstack-tripleo-heat-templates/environments/enable-swap.yaml \
     -e /usr/share/openstack-tripleo-heat-templates/environments/podman.yaml \
     -e /usr/share/openstack-tripleo-heat-templates/environments/ceph-ansible/ceph-ansible.yaml \
     -e ../edge-common/endpoint-map.json \
     -e ../edge-common/all-nodes-extra-map-data.yaml \
     -e ../edge-common/global-config-extra-map-data.json \
     -e ../edge-common/extra-host-file-entries.json \
     -e ../edge-common/passwords.yaml \
     -e ~/containers-env-file.yaml \
     -e ceph.yaml \
     -e overrides.yaml
