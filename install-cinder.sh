#!/bin/bash

apt-get install -y cinder-api cinder-scheduler cinder-volume iscsitarget \
    open-iscsi iscsitarget-dkms python-cinderclient linux-headers-$(uname -r)

sed -i 's/false/true/g' /etc/default/iscsitarget

service iscsitarget start
service open-iscsi start

cat << EOF > /tmp/cinder.conf.path
[DEFAULT]
sql_connection = mysql://cinder:swordfish@localhost/cinder
rabbit_password = guest
EOF


cat << EOF > /tmp/api-paste.ini.part
admin_tenant_name = service
admin_user = cinder
admin_password = swordfish
EOF

dd if=/dev/zero of=/opt/cinder-volumes.img bs=100 count=100M
sleep 5

losetup /dev/loop0 /opt/cinder-columes.img
sleep 5

sfdisk /dev/loop0 << EOF
,,8e,,
EOF

pvcreate /dev/loop0
vgcreate cinder-volumes /dev/loop0

cinder-manage db sync

./restart-os-services.sh cinder
