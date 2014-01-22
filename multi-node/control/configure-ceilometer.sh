#!/bin/bash

source ../openrc

#-------------------------------------------------------------------------------

cat << EOF > /etc/mongodb.conf.changes
bind_ip = $CONTROL_IP
EOF

#-------------------------------------------------------------------------------

service mongodb restart
./initialize-mongodb.sh

#-------------------------------------------------------------------------------

cat << EOF > /etc/ceilometer/ceilometer.conf.changes
[database]
connection = mongodb://ceilometer:$MONGODB_PASSWORD@$CONTROL_IP:27017/ceilometer
# Secret value for signing metering messages (string value)
metering_secret = $ADMIN_TOKEN
rabbit_host = guest
rabbit_password = guest
#keystone auth
auth_host = $CONTROL_IP
auth_port = 35357
auth_protocol = http
admin_tenant_name = $SERVICE_TENANT_NAME
admin_user = ceilometer
admin_password = $SERVICE_PASSWORD
EOF

#-------------------------------------------------------------------------------

./merge-config.sh /etc/ceilometer/ceilometer.conf /etc/ceilometer/ceilometer.conf.changes

#-------------------------------------------------------------------------------

./restart-os-services.sh ceilometer
