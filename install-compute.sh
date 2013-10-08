#!/bin/bash

#apt-get -y install python-dev

#easy_install pip

#pip install --upgrade websockify

apt-get install -y nova-api nova-cert nova-common nova-conductor \
    nova-scheduler python-nova python-novaclient nova-consoleauth novnc \
    nova-novncproxy

#-------------------------------------------------------------------------------

cat << EOF > /tmp/api-paste.ini.part
[filter:authtoken]
admin_tenant_name = service
admin_user = nova
admin_password = password
EOF

#-------------------------------------------------------------------------------

cat << EOF > /tmp/nova.conf.part
[DEFAULT]
sql_connection=mysql://nova:swordfish@localhost/nova
my_ip=10.10.10.10
rabbit_password=guest
auth_strategy=keystone

# Networking
network_api_class=nova.network.quantumv2.api.API
quantum_url=http://127.0.0.1:9696
quantum_auth_strategy=keystone
quantum_admin_tenant_name=service
quantum_admin_username=quantum
quantum_admin_password=password
quantum_admin_auth_url=http://127.0.0.1:35357/v2.0
libvirt_vif_driver=nova.virt.libvirt.vif.LibvirtHybridOVSBridgeDriver
linuxnet_interface_driver=nova.network.linux_net.LinuxOVSInterfaceDriver

# Security Groups
firewall_driver=nova.virt.firewall.NoopFirewallDriver
security_group_api=quantum

# Metadata
quantum_metadata_proxy_shared_secret=password
service_quantum_metadata_proxy=true
metadata_listen = 10.10.10.10
metadata_listen_port = 8775

# Cinder
volume_api_class=nova.volume.cinder.API

# Glance
glance_api_servers=127.0.0.1:9292
image_service=nova.image.glance.GlanceImageService

# novnc
novnc_enable=true
novncproxy_port=6080
#novncproxy_host=10.0.0.10
vncserver_listen=0.0.0.0
EOF

#-------------------------------------------------------------------------------

#./merge-config.sh /etc/nova/api-paste.ini /tmp/api-paste.ini.part
#./merge-config.sh /etc/nova/nova.conf /tmp/nova.conf.part
