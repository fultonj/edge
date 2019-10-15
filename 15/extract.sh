#!/bin/bash

SRC=central
DIR=edge-common
if [[ -d $DIR ]]; then
    rm -rf $DIR
fi
mkdir $DIR

# AllNodesConfig: Node specific hieradata (hostnames, etc) set on all nodes
ALL_NODES_CONFIG=/var/lib/mistral/$SRC/group_vars/overcloud.yaml
if [[ ! -e $ALL_NODES_CONFIG ]]; then
    echo "Cannot find $ALL_NODES_CONFIG"
    exit 1
fi
python3 -c "import yaml; data=yaml.safe_load(open('$ALL_NODES_CONFIG').read()); print(yaml.dump(dict(parameter_defaults=dict(AllNodesExtraMapData=data))))" > $DIR/all-nodes-extra-map-data.yaml

source ~/stackrc
# EndpointMap: Cloud service to URL mapping
openstack stack output show $SRC EndpointMap --format json | jq '{"parameter_defaults": {"EndpointMapOverride": .output_value}}' > $DIR/endpoint-map.json

# HostsEntry: Entries for /etc/hosts set on all nodes
openstack stack output show $SRC HostsEntry -f json | jq -r '{"parameter_defaults":{"ExtraHostFileEntries": .output_value}}' > $DIR/extra-host-file-entries.json

# GlobalConfig: Service specific hieradata set on all nodes
openstack stack output show $SRC GlobalConfig --format json \
  | jq '{"parameter_defaults": {"GlobalConfigExtraMapData": .output_value}}' \
  > $DIR/global-config-extra-map-data.json

# The same passwords and secrets should be reused in additional compute stacks
openstack object save $SRC plan-environment.yaml
python3 -c "import yaml; data=yaml.safe_load(open('plan-environment.yaml').read()); print(yaml.dump(dict(parameter_defaults=data['passwords'])))" > $DIR/passwords.yaml
rm -f plan-environment.yaml

# Show user overview of extracted data
wc -l $DIR/*
