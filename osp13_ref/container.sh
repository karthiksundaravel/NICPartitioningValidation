#!/bin/bash

openstack overcloud container image prepare   \
  -r ~/templates/osp14_ref/roles_data.yaml \
  -e /usr/share/openstack-tripleo-heat-templates/environments/network-isolation.yaml \
  -e /usr/share/openstack-tripleo-heat-templates/environments/network-environment.yaml \
  -e /usr/share/openstack-tripleo-heat-templates/environments/neutron-ovs-dpdk.yaml \
  -e /usr/share/openstack-tripleo-heat-templates/environments/host-config-and-reboot.yaml \
  -e /usr/share/openstack-tripleo-heat-templates/environments/disable-telemetry.yaml \
  -e /usr/share/openstack-tripleo-heat-templates/environments/neutron-sriov.yaml \
  -e ~/templates/osp14_ref/environment.yaml \
  -e ~/templates/osp14_ref/network-environment.yaml \
  -e ~/templates/osp14_ref/routed-environment.yaml \
  -e ~/templates/osp14_ref/ml2-ovs-dpdk-env.yaml\
  --namespace docker-registry.engineering.redhat.com/rhosp13  \
  --prefix "openstack-" \
  --tag 2018-12-13.4 \
  --env-file docker_registry.yaml
