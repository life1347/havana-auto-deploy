#!/bin/bash

#-------------------------------------------------------------------------------

cat << EOF > /etc/neutron/neutron.conf.changes
[DEFAULT]
debug = True
verbose = True
bind_host = 0.0.0.0
bind_port = 9696
api_paste_config = api-paste.ini
rabbit_password = guest
[keystone_authtoken]
admin_tenant_name = service
admin_user = quantum
admin_password = swordfish
[database]
connection = mysql://quantum:swordfish@localhost/quantum
EOF

#-------------------------------------------------------------------------------

cat << EOF > /etc/neutron/plugins/openvswitch/ovs_neutron_plugin.ini.changes
[DATABASE]
connection = mysql://quantum:swordfish@localhost/quantum
[OVS]
#tenant_network_type = gre
#tunnel_id_ranges = 1:1000
#enable_tunneling = True
#local_ip = 127.0.0.1
[securitygroup]
firewall_driver = neutron.agent.linux.iptables_firewall.OVSHybridIptablesFirewallDriver
EOF

#-------------------------------------------------------------------------------

cat << EOF > /etc/neutron/dhcp_agent.ini.changes
[DEFAULT]
debug = True
interface_driver = neutron.agent.linux.interface.OVSInterfaceDriver
dhcp_driver = neutron.agent.linux.dhcp.Dnsmasq
use_namespaces = True
enable_isolated_metadata = True
enable_metadata_network = True
EOF

#-------------------------------------------------------------------------------

cat << EOF > /etc/quantum/metadata_agent.ini.changes
[DEFAULT]
auth_url = http://127.0.0.1:35357/v2.0
auth_region = RegionOne
admin_tenant_name = service
admin_user = quantum
admin_password = swordfish
nova_metadata_ip = 10.10.10.10
nova_metadata_port = 8775
metadata_proxy_shared_secret = swordfish
EOF

#-------------------------------------------------------------------------------

./merge-config.sh /etc/neutron/neutron.conf /etc/neutron/neutron.conf.changes

./merge-config.sh /etc/neutron/plugins/openvswitch/ovs_neutron_plugin.ini \
    /etc/neutron/plugins/openvswitch/ovs_neutron_plugin.ini.changes

./merge-config.sh /etc/neutron/dhcp_agent.ini /etc/neutron/dhcp_agent.ini.changes

./merge-config.sh /etc/quantum/metadata_agent.ini /etc/quantum/metadata_agent.ini.changes

#-------------------------------------------------------------------------------

ln -s /etc/neutron/plugins/openvswitch/ovs_neutron_plugin.ini /etc/neutron/plugin.ini

./restart-os-services.sh neutron
