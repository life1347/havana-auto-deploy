#!/bin/bash

apt-get -y install neutron-server

#-------------------------------------------------------------------------------

cat << EOF > /etc/neutron/neutron.conf.changes
[DEFAULT]
verbose = True
rabbit_password = guest
[keystone_authtoken]
admin_tenant_name = service
admin_user = quantum
admin_password = swordfish
EOF

#-------------------------------------------------------------------------------

cat << EOF > /etc/neutron/plugins/openvswitch/ovs_quantum_plugin.ini.changes
[DATABASE]
sql_connection = mysql://quantum:swordfish@localhost/quantum
[OVS]
tenant_network_type = gre 
tunnel_id_ranges = 1:1000
enable_tunneling = True
local_ip = 10.10.10.10
[SECURITYGROUP]
firewall_driver = neutron.agent.linux.iptables_firewall.OVSHybridIptablesFirewallDriver
EOF

#-------------------------------------------------------------------------------

./merge-config.py /etc/neutron/neutron.conf /etc/neutron/neutron.conf.changes
./merge-config.py /etc/neutron/plugins/openvswitch/ovs_quantum_plugin.ini \
    /etc/neutron/plugins/openvswitch/ovs_quantum_plugin.ini.changes

ln -s /etc/neutron/plugins/openvswitch/ovs_quantum_plugin.ini /etc/neutron/plugin.ini

service neutron-server restart
