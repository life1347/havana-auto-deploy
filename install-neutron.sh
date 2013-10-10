#!/bin/bash

apt-get install --yes neutron-server neutron-plugin-openvswitch-agent \
    neutron-dhcp-agent neutron-l3-agent

service openvswitch-switch start
