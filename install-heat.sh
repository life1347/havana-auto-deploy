#!/bin/bash

apt-get -y install heat-api heat-api-cfn heat-api-cloudwatch \
    heat-common heat-engine python-heat python-heatclient

cat << EOF > /tmp/heat-api-paste.ini.part
[filter:authtoken]
auth_host = 127.0.0.1
auth_port = 35357
auth_protocol = http
auth_uri = http://127.0.0.1:5000/v2.0
admin_tenant_name = admin
admin_user = admin
admin_password = swordfish
EOF


cat << EOF > /tmp/heat.conf.part
[DEFAULT]
debug=True
verbose=True
log_dir=/var/log/heat
EOF

./merge-config.py /etc/heat/api-paste.ini /tmp/heat-api-paste.ini.part
./merge-config.py /etc/heat/heat.conf /tmp/heat.conf.part

./restart-os-services.sh heat
