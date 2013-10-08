#!/bin/bash

apt-get -y install sheepdog glance


cat << EOF > /tmp/glance.config
[DEFAULT]
sql_connection = mysql://glance:password@localhost/glance

[keystone_authtoken]
admin_tenant_name = service
admin_user = glance
admin_password = password

[paste_deploy]
flavor=keystone
EOF

#./merge-config.sh /etc/glance/glance-api.conf /tmp/glance.config
#./merge-config.sh /etc/glance/glance-registry.conf /tmp/glance.config

service glance-api restart && service glance-registry restart

glance-manage db_sync
