#!/bin/bash

#-------------------------------------------------------------------------------

cat << EOF > /etc/keystone/keystone.conf.changes
[DEFAULT]
admin_token = swordfish
debug = True
verbose = True

[sql]
connection = mysql://keystone:swordfish@localhost/keystone
EOF

#-------------------------------------------------------------------------------

./merge-config.sh /etc/keystone/keystone.conf /etc/keystone/keystone.conf.changes

service keystone restart

keystone-manage db_sync
