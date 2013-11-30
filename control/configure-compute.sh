#!/bin/bash

source ./openrc

#-------------------------------------------------------------------------------

cat << EOF > /etc/nova/api-paste.ini.changes
[filter:authtoken]
paste.filter_factory = keystoneclient.middleware.auth_token:filter_factory
auth_host = $HOST_IP
auth_port = 35357
auth_protocol = http
admin_tenant_name = service
admin_user = nova
admin_password = swordfish
signing_dirname = /tmp/keystone-signing-nova
# Workaround for https://bugs.launchpad.net/nova/+bug/1154809
auth_version = v2.0
EOF

#-------------------------------------------------------------------------------

cat << EOF > /etc/nova/nova.conf.changes
[DEFAULT]
sql_connection = mysql://nova:swordfish@$HOST_IP/nova
my_ip = $HOST_IP
rabbit_password = guest
auth_strategy = keystone

# Networking
network_api_class = nova.network.neutronv2.api.API
neutron_url = http://$HOST_IP:9696
neutron_auth_strategy = keystone
neutron_admin_tenant_name = service
neutron_admin_username = neutron
neutron_admin_password = swordfish
neutron_admin_auth_url = http://$HOST_IP:35357/v2.0
libvirt_vif_driver = nova.virt.libvirt.vif.LibvirtHybridOVSBridgeDriver
linuxnet_interface_driver = nova.network.linux_net.LinuxOVSInterfaceDriver

# Security Groups
firewall_driver = nova.virt.firewall.NoopFirewallDriver
security_group_api = neutron

# Metadata
neutron_metadata_proxy_shared_secret = swordfish
service_neutron_metadata_proxy = True
metadata_listen = $HOST_IP
metadata_listen_port = 8775
metadata_host = $HOST_IP

# Cinder
volume_api_class = nova.volume.cinder.API

# Glance
glance_api_servers = $HOST_IP:9292
image_service = nova.image.glance.GlanceImageService

# novnc
novnc_enabled = True
novncproxy_port = 6080
vncserver_listen = 0.0.0.0
vncserver_proxyclient_address = $HOST_IP
novncproxy_base_url = http://$HOST_IP:6080/vnc_auto.html
EOF

#-------------------------------------------------------------------------------

kvm-ok
if [ $? -eq 0 ] ; then
    libvirt_type='kvm'
else
    libvirt_type='qemu'
fi

cat << EOF > /etc/nova/nova-compute.conf.changes
[DEFAULT]
libvirt_type = $libvirt_type
libvirt_ovs_bridge=br-int
libvirt_vif_type=ethernet
libvirt_vif_driver=nova.virt.libvirt.vif.LibvirtHybridOVSBridgeDriver
libvirt_use_virtio_for_bridges=True
EOF

#-------------------------------------------------------------------------------

./merge-config.sh /etc/nova/api-paste.ini /etc/nova/api-paste.ini.changes

./merge-config.sh /etc/nova/nova.conf /etc/nova/nova.conf.changes

./merge-config.sh /etc/nova/nova-compute.conf /etc/nova/nova-compute.conf.changes


nova-manage db sync
