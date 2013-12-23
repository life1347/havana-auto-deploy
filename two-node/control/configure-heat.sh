#!/bin/bash

source ../openrc

#-------------------------------------------------------------------------------

cat << EOF > /etc/heat/api-paste.ini.changes
[filter:authtoken]
auth_host = $HOST_IP_ETH1
auth_port = 35357
auth_protocol = http
auth_uri = http://$HOST_IP_ETH1:5000/v2.0
admin_tenant_name = $SERVICE_TENANT_NAME
admin_user = heat
admin_password = $SERVICE_PASSWORD
EOF

#-------------------------------------------------------------------------------

cat << EOF > /etc/heat/heat.conf.changes
[DEFAULT]
debug = $DEBUG_OPEN
verbose = $VERBOSE_OPEN
log_dir = /var/log/heat
sql_connection = mysql://heat:$MYSQL_PASSWORD@$HOST_IP_ETH1/heat
rabbit_host = $HOST_IP_ETH1
rabbit_password = guest

#keystone authtoken
auth_host = $HOST_IP_ETH1
auth_port = 35357
auth_protocol = http
auth_uri = http://$HOST_IP_ETH1:5000/v2.0
admin_tenant_name = $SERVICE_TENANT_NAME
admin_user = heat
admin_password = $SERVICE_PASSWORD

#EC2 authtoken
auth_uri = http://$HOST_IP_ETH1:5000/v2.0
keystone_ec2_uri = http://$HOST_IP_ETH1:5000/v2.0/ec2tokens
EOF

#-------------------------------------------------------------------------------

./merge-config.sh /etc/heat/api-paste.ini /etc/heat/api-paste.ini.changes

./merge-config.sh /etc/heat/heat.conf /etc/heat/heat.conf.changes

#-------------------------------------------------------------------------------

heat-manage db_sync

./restart-os-services.sh heat
