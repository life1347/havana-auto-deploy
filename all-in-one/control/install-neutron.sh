#!/bin/bash

apt-get install --yes \
	neutron-server \
	openvswitch-switch \
    openvswitch-datapath-dkms \
    neutron-plugin-openvswitch-agent \
    neutron-dhcp-agent \
    neutron-l3-agent \
    neutron-metadata-agent

service neutron-server restart

service openvswitch-switch restart

ovs-vsctl add-br br-ex
ovs-vsctl add-br br-int

sed -i 's/iface eth2 inet dhcp/iface eth2 inet manual/g' /etc/network/interfaces
echo 'up ifconfig $IFACE 0.0.0.0 up' >> /etc/network/interfaces
echo 'up ip link set $IFACE promisc on' >> /etc/network/interfaces
echo 'down ip link set $IFACE promisc off' >> /etc/network/interfaces
echo 'down ifconfig $IFACE down' >> /etc/network/interfaces

ovs-vsctl add-port br-ex eth2