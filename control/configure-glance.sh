#!/bin/bash

source ../openrc

#-------------------------------------------------------------------------------

cat << EOF > /etc/glance/glance-api.conf.changes
[DEFAULT]
debug = $DEBUG_OPEN
verbose = $VERBOSE_OPEN
sql_connection = mysql://glance:swordfish@$HOST_IP/glance

[keystone_authtoken]
auth_host = $HOST_IP
auth_port = 35357
auth_protocol = http
admin_tenant_name = service
admin_user = glance
admin_password = swordfish

[paste_deploy]
flavor = keystone
EOF

#-------------------------------------------------------------------------------

./merge-config.sh /etc/glance/glance-api.conf /etc/glance/glance-api.conf.changes

./merge-config.sh /etc/glance/glance-registry.conf /etc/glance/glance-api.conf.changes

./restart-os-services.sh glance

glance-manage db_sync
