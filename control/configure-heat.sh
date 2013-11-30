#!/bin/bash

source ./openrc

#-------------------------------------------------------------------------------

cat << EOF > /etc/heat/api-paste.ini.changes
[filter:authtoken]
auth_host = $HOST_IP
auth_port = 35357
auth_protocol = http
auth_uri = http://$HOST_IP:5000/v2.0
admin_tenant_name = admin
admin_user = admin
admin_password = swordfish
EOF

#-------------------------------------------------------------------------------

cat << EOF > /etc/heat/heat.conf.changes
[DEFAULT]
debug = $DEBUG_OPEN
verbose = $VERBOSE_OPEN
log_dir = /var/log/heat
EOF

#-------------------------------------------------------------------------------

./merge-config.sh /etc/heat/api-paste.ini /etc/heat/api-paste.ini.changes

./merge-config.sh /etc/heat/heat.conf /etc/heat/heat.conf.changes

#-------------------------------------------------------------------------------

./restart-os-services.sh heat
