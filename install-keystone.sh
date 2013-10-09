#!/bin/bash

apt-get install -y keystone python-keystone python-keystoneclient

cat << EOF > /tmp/keystone.config
[DEFAULT]
admin_token = password
debug = True
verbose = True

[sql]
connection = mysql://keystone:password@localhost/keystone
EOF

./merge-config.py /etc/keystone/keystone.conf /tmp/keystone.config

service keystone restart

keystone-manage db_sync
