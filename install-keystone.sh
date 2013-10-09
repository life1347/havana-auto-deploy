#!/bin/bash

apt-get install -y keystone python-keystone python-keystoneclient

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

./merge-config.py /etc/keystone/keystone.conf /etc/keystone/keystone.conf.changes

service keystone restart

keystone-manage db_sync
