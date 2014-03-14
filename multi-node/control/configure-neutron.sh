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

rabbit_host = $CONTROL_IP
rabbit_userid = guest
rabbit_password = guest

#for ml2
core_plugin = neutron.plugins.ml2.plugin.Ml2Plugin
service_plugins = neutron.services.l3_router.l3_router_plugin.L3RouterPlugin

[keystone_authtoken]
auth_host = $CONTROL_IP
auth_port = 35357
auth_protocol = http
admin_tenant_name = $SERVICE_TENANT_NAME
admin_user = neutron
admin_password = $SERVICE_PASSWORD

#[database]
#connection = mysql://neutron:$MYSQL_PASSWORD@$CONTROL_IP/neutron

[quotas]
quota_driver = neutron.db.quota_db.DbQuotaDriver
EOF

#-------------------------------------------------------------------------------
#cat << EOF > /etc/neutron/plugins/openvswitch/ovs_neutron_plugin.ini.changes
#[database]
#sql_connection = mysql://neutron:$MYSQL_PASSWORD@$CONTROL_IP/neutron

#[ovs]
#tenant_network_type = gre
#tunnel_id_ranges = 1:1000
#integration_bridge = br-int
#tunnel_bridge = br-tun
#local_ip = $CONTROL_IP
#enable_tunneling = True

#[securitygroup]
#firewall_driver = neutron.agent.linux.iptables_firewall.OVSHybridIptablesFirewallDriver
#EOF

#-------------------------------------------------------------------------------

mkdir /etc/neutron/plugins/ml2/
wget -O /etc/neutron/plugins/ml2/ml2_conf.ini https://raw.github.com/openstack/neutron/master/etc/neutron/plugins/ml2/ml2_conf.ini

cat << EOF > /etc/neutron/plugins/ml2/ml2_conf.ini.changes
[ml2]
type_drivers = local,gre
tenant_network_types = local,gre
mechanism_drivers = opendaylight 
[ml2_type_gre]
tunnel_id_ranges = 1:1000
[database]
sql_connection = mysql://neutron:$MYSQL_PASSWORD@$CONTROL_IP/neutron?charset=utf8
[ovs]
enable_tunneling = True
local_ip = 10.211.55.89
[agent]
tunnel_types = gre
root_helper = sudo /usr/bin/neutron-rootwrap /etc/neutron/rootwrap.conf
[agent]
minimize_polling = True
[securitygroup]
firewall_driver = neutron.agent.linux.iptables_firewall.OVSHybridIptablesFirewallDriver
EOF

./merge-config.sh /etc/neutron/plugins/ml2/ml2_conf.ini \
    /etc/neutron/plugins/ml2/ml2_conf.ini.changes

sed -i 's/\/etc\/neutron\/plugins\/openvswitch\/ovs_neutron_plugin.ini/\/etc\/neutron\/plugins\/ml2\/ml2_conf.ini/g' /etc/default/neutron-server

#-------------------------------------------------------------------------------

./merge-config.sh /etc/neutron/neutron.conf /etc/neutron/neutron.conf.changes

#./merge-config.sh /etc/neutron/plugins/openvswitch/ovs_neutron_plugin.ini \
#    /etc/neutron/plugins/openvswitch/ovs_neutron_plugin.ini.changes

#-------------------------------------------------------------------------------

ln -s /etc/neutron/plugins/openvswitch/ovs_neutron_plugin.ini /etc/neutron/plugin.ini

./restart-os-services.sh neutron

./configure-neutron-network.sh
