#!/bin/bash

source ../openrc

#-------------------------------------------------------------------------------

cat << EOF > /etc/keystone/keystone.conf.changes
[DEFAULT]
admin_token = swordfish
debug = $DEBUG_OPEN
verbose = $VERBOSE_OPEN

[sql]
connection = mysql://keystone:swordfish@$HOST_IP/keystone
EOF

#-------------------------------------------------------------------------------

./merge-config.sh /etc/keystone/keystone.conf /etc/keystone/keystone.conf.changes

service keystone restart

keystone-manage db_sync
