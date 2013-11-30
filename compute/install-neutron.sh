#!/bin/bash

apt-get install --yes \
	neutron-server \
	neutron-plugin-openvswitch-agent \
    neutron-dhcp-agent \
    neutron-l3-agent \
    openvswitch-switch \
    openvswitch-datapath-dkms

service openvswitch-switch start

ovs-vsctl add-br br-int
