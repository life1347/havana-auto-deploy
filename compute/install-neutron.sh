#!/bin/bash

apt-get install --yes \
	neutron-plugin-openvswitch-agent \
    openvswitch-switch \
    openvswitch-datapath-dkms

service openvswitch-switch start

ovs-vsctl add-br br-int
