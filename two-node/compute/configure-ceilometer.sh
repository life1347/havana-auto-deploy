#!/bin/bash

source ../openrc

#-------------------------------------------------------------------------------

cat << EOF > /etc/nova/nova.conf.changes
[DEFAULT]
instance_usage_audit=True
instance_usage_audit_period=hour
notify_on_state_change=vm_and_task_state
notification_driver=nova.openstack.common.notifier.rpc_notifier
notification_driver=ceilometer.compute.nova_notifier
EOF

#-------------------------------------------------------------------------------

cat << EOF > /etc/ceilometer/ceilometer.conf.changes
[publisher_rpc]
metering_secret = $ADMIN_TOKEN
EOF

#-------------------------------------------------------------------------------

./merge-config.sh /etc/ceilometer/ceilometer.conf /etc/ceilometer/ceilometer.conf.changes

#-------------------------------------------------------------------------------

./restart-os-services.sh ceilometer
