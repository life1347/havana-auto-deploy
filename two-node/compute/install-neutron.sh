#!/bin/bash

apt-get install --yes \
    openvswitch-switch \
    openvswitch-datapath-dkms \
    neutron-plugin-openvswitch-agent

service openvswitch-switch restart

ovs-vsctl add-br br-int
