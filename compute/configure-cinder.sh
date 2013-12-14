#!/bin/bash

source ../openrc

#-------------------------------------------------------------------------------

cat << EOF > /etc/cinder/cinder.conf.changes
[DEFAULT]
sql_connection = mysql://cinder:$MYSQL_PASSWORD@$HOST_IP/cinder
rabbit_password = guest
EOF

#-------------------------------------------------------------------------------

cat << EOF > /etc/cinder/api-paste.ini.changes
[filter:authtoken]
paste.filter_factory = keystoneclient.middleware.auth_token:filter_factory
auth_host = $HOST_IP
auth_port = 35357
auth_protocol = http
admin_tenant_name = $SERVICE_TENANT_NAME
admin_user = cinder
admin_password = $SERVICE_PASSWORD
EOF

#-------------------------------------------------------------------------------

./merge-config.sh /etc/cinder/cinder.conf /etc/cinder/cinder.conf.changes

./merge-config.sh /etc/cinder/api-paste.ini /etc/cinder/api-paste.ini.changes

cinder-manage db sync

./restart-os-services.sh cinder
