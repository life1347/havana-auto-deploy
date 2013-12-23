#!/bin/bash

source ../openrc

#-------------------------------------------------------------------------------

cat << EOF > /etc/keystone/keystone.conf.changes
[DEFAULT]
admin_token = $ADMIN_TOKEN
debug = $DEBUG_OPEN
verbose = $VERBOSE_OPEN

[sql]
connection = mysql://keystone:$MYSQL_PASSWORD@$HOST_IP_ETH1/keystone
EOF

#-------------------------------------------------------------------------------

./merge-config.sh /etc/keystone/keystone.conf /etc/keystone/keystone.conf.changes

service keystone restart

keystone-manage db_sync
