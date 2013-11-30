#!/bin/bash

source ../openrc

#-------------------------------------------------------------------------------

cat << EOF > /etc/neutron/neutron.conf.changes
[DEFAULT]
debug = $DEBUG_OPEN
verbose = $VERBOSE_OPEN

bind_host = 0.0.0.0
bind_port = 9696

allow_overlapping_ips = True

api_paste_config = api-paste.ini

rabbit_host = $HOST_IP
rabbit_userid = guest
rabbit_password = guest

[keystone_authtoken]
auth_host = $HOST_IP
auth_port = 35357
auth_protocol = http
admin_tenant_name = service
admin_user = neutron
admin_password = swordfish

[database]
connection = mysql://neutron:swordfish@$HOST_IP/neutron

[quotas]
quota_driver = neutron.db.quota_db.DbQuotaDriver
EOF

#-------------------------------------------------------------------------------

cat << EOF > /etc/neutron/plugins/openvswitch/ovs_neutron_plugin.ini.changes
[database]
sql_connection = mysql://neutron:swordfish@$HOST_IP/neutron

[ovs]
tenant_network_type = gre
tunnel_id_ranges = 1:1000
integration_bridge = br-int
tunnel_bridge = br-tun
local_ip = $NETWORK_IP_ETH1
enable_tunneling = True

[securitygroup]
firewall_driver = neutron.agent.linux.iptables_firewall.OVSHybridIptablesFirewallDriver
EOF

#-------------------------------------------------------------------------------

cat << EOF > /etc/neutron/dhcp_agent.ini.changes
[DEFAULT]
debug = $DEBUG_OPEN
#ovs_use_veth = True
interface_driver = neutron.agent.linux.interface.OVSInterfaceDriver
dhcp_driver = neutron.agent.linux.dhcp.Dnsmasq
use_namespaces = True
enable_isolated_metadata = True
enable_metadata_network = True
#dnsmasq_config_file = /etc/neutron/dnsmasq-neutron.conf
EOF

#-------------------------------------------------------------------------------

cat << EOF > /etc/neutron/metadata_agent.ini.changes
[DEFAULT]
auth_url = http://$HOST_IP:35357/v2.0
auth_region = RegionOne
admin_tenant_name = service
admin_user = neutron
admin_password = swordfish
nova_metadata_ip = $HOST_IP
nova_metadata_port = 8775
metadata_proxy_shared_secret = swordfish
EOF

#-------------------------------------------------------------------------------

cat << EOF > /etc/neutron/dnsmasq-neutron.conf
dhcp-option-force = 26,1400
EOF

#-------------------------------------------------------------------------------

cat << EOF > /etc/neutron/l3_agent.ini.changes
[DEFAULT]
debug = $DEBUG_OPEN
#ovs_use_veth = True
interface_driver = neutron.agent.linux.interface.OVSInterfaceDriver
use_namespaces = True
external_network_bridge = br-ex
metadata_port = 9697
enable_metadata_proxy = True
EOF

#-------------------------------------------------------------------------------

./merge-config.sh /etc/neutron/neutron.conf /etc/neutron/neutron.conf.changes

./merge-config.sh /etc/neutron/plugins/openvswitch/ovs_neutron_plugin.ini \
    /etc/neutron/plugins/openvswitch/ovs_neutron_plugin.ini.changes

./merge-config.sh /etc/neutron/dhcp_agent.ini /etc/neutron/dhcp_agent.ini.changes

./merge-config.sh /etc/neutron/l3_agent.ini /etc/neutron/l3_agent.ini.changes

./merge-config.sh /etc/neutron/metadata_agent.ini /etc/neutron/metadata_agent.ini.changes

#-------------------------------------------------------------------------------

ln -s /etc/neutron/plugins/openvswitch/ovs_neutron_plugin.ini /etc/neutron/plugin.ini

./restart-os-services.sh neutron
