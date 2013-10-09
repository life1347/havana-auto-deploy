#!/bin/bash

#-------------------------------------------------------------------------------

cat << EOF > /etc/nova/api-paste.ini.changes
[filter:authtoken]
admin_tenant_name = service
admin_user = nova
admin_password = swordfish
EOF

#-------------------------------------------------------------------------------

cat << EOF > /etc/nova/nova.conf.changes
[DEFAULT]
sql_connection=mysql://nova:swordfish@localhost/nova
my_ip=10.10.10.10
rabbit_password=guest
auth_strategy=keystone

# Networking
network_api_class=nova.network.neutronv2.api.API
neutron_url=http://127.0.0.1:9696
neutron_auth_strategy=keystone
neutron_admin_tenant_name=service
neutron_admin_username=quantum
neutron_admin_password=swordfish
neutron_admin_auth_url=http://127.0.0.1:35357/v2.0
libvirt_vif_driver=nova.virt.libvirt.vif.LibvirtHybridOVSBridgeDriver
linuxnet_interface_driver=nova.network.linux_net.LinuxOVSInterfaceDriver

# Security Groups
firewall_driver=nova.virt.firewall.NoopFirewallDriver
security_group_api=neutron

# Metadata
neutron_metadata_proxy_shared_secret=swordfish
service_neutron_metadata_proxy=true
metadata_listen = 127.0.0.1
metadata_listen_port = 8775
metadata_host = 127.0.0.1

# Cinder
volume_api_class=nova.volume.cinder.API

# Glance
glance_api_servers=127.0.0.1:9292
image_service=nova.image.glance.GlanceImageService

# novnc
novnc_enabled=true
novncproxy_port=6080
vncserver_listen=0.0.0.0
vncserver_proxyclient_address=10.10.10.10
novncproxy_base_url=http://10.10.10.10:6080/vnc_auto.html
EOF

#-------------------------------------------------------------------------------

cat << EOF > /etc/nova/nova-compute.conf.changes
[DEFAULT]
libvirt_type=qemu
EOF

#-------------------------------------------------------------------------------

./merge-config.sh /etc/nova/api-paste.ini /etc/nova/api-paste.ini.changes

./merge-config.sh /etc/nova/nova.conf /etc/nova/nova.conf.changes

./merge-config.sh /etc/nova/nova-compute.conf /etc/nova/nova-compute.conf.changes
