#!/bin/bash

apt-get -y install neutron-server neutron-plugin-openvswitch-agent \
    neutron-dhcp-agent neutron-l3-agent

service openvswitch-switch start
