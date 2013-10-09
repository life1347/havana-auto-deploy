#!/bin/bash

#-------------------------------------------------------------------------------

cat << EOF > /etc/heat/api-paste.ini.changes
[filter:authtoken]
auth_host = 127.0.0.1
auth_port = 35357
auth_protocol = http
auth_uri = http://127.0.0.1:5000/v2.0
admin_tenant_name = admin
admin_user = admin
admin_password = swordfish
EOF

#-------------------------------------------------------------------------------

cat << EOF > /etc/heat/heat.conf.changes
[DEFAULT]
debug=True
verbose=True
log_dir=/var/log/heat
EOF

#-------------------------------------------------------------------------------

./merge-config.py /etc/heat/api-paste.ini /etc/heat/api-paste.ini.changes

./merge-config.py /etc/heat/heat.conf /etc/heat/heat.conf.changes

#-------------------------------------------------------------------------------

./restart-os-services.sh heat
