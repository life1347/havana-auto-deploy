#!/bin/bash

source ../openrc

# Shortcut function to get a newly generated ID
function get_field() {
    while read data; do
        if [ "$1" -lt 0 ]; then
            field="(\$(NF$1))"
        else
            field="\$$(($1 + 1))"
        fi
        echo "$data" | awk -F'[ \t]*\\|[ \t]*' "{print $field}"
    done
}


# Tenants
ADMIN_TENANT=$(keystone tenant-create \
  --name admin | grep " id " | get_field 2)

DEMO_TENANT=$(keystone tenant-create \
  --name demo | grep " id " | get_field 2)

SERVICE_TENANT=$(keystone tenant-create \
  --name $SERVICE_TENANT_NAME | grep " id " | get_field 2)


# Users
ADMIN_USER=$(keystone user-create \
  --name admin \
  --pass "$ADMIN_PASSWORD" \
  --email admin@domain.com | grep " id " | get_field 2)

DEMO_USER=$(keystone user-create \
  --name demo \
  --pass "$DEMO_PASSWORD" \
  --email demo@domain.com \
  --tenant-id $DEMO_TENANT | grep " id " | get_field 2)

NOVA_USER=$(keystone user-create \
  --name nova \
  --pass "$SERVICE_PASSWORD" \
  --tenant-id $SERVICE_TENANT \
  --email nova@domain.com | grep " id " | get_field 2)

GLANCE_USER=$(keystone user-create \
  --name glance \
  --pass "$SERVICE_PASSWORD" \
  --tenant-id $SERVICE_TENANT \
  --email glance@domain.com | grep " id " | get_field 2)

QUANTUM_USER=$(keystone user-create \
  --name neutron \
  --pass "$SERVICE_PASSWORD" \
  --tenant-id $SERVICE_TENANT \
  --email neutron@domain.com | grep " id " | get_field 2)

CINDER_USER=$(keystone user-create \
  --name cinder \
  --pass "$SERVICE_PASSWORD" \
  --tenant-id $SERVICE_TENANT \
  --email cinder@domain.com | grep " id " | get_field 2)

HEAT_USER=$(keystone user-create \
  --name heat \
  --pass "$SERVICE_PASSWORD" \
  --tenant-id $SERVICE_TENANT \
  --email heat@domain.com | grep " id " | get_field 2)

CEILOMETER_USER=$(keystone user-create \
  --name ceilometer \
  --pass "$SERVICE_PASSWORD" \
  --tenant-id $SERVICE_TENANT \
  --email ceilometer@domain.com | grep " id " | get_field 2)

# Roles
ADMIN_ROLE=$(keystone role-create --name=admin | grep " id " | get_field 2)
MEMBER_ROLE=$(keystone role-create --name=Member | grep " id " | get_field 2)

# Add Roles to Users in Tenants
keystone user-role-add --user-id $ADMIN_USER --role-id $ADMIN_ROLE --tenant-id $ADMIN_TENANT
keystone user-role-add --tenant-id $SERVICE_TENANT --user-id $NOVA_USER --role-id $ADMIN_ROLE
keystone user-role-add --tenant-id $SERVICE_TENANT --user-id $GLANCE_USER --role-id $ADMIN_ROLE
keystone user-role-add --tenant-id $SERVICE_TENANT --user-id $QUANTUM_USER --role-id $ADMIN_ROLE
keystone user-role-add --tenant-id $SERVICE_TENANT --user-id $CINDER_USER --role-id $ADMIN_ROLE
keystone user-role-add --tenant-id $SERVICE_TENANT --user-id $HEAT_USER --role-id $ADMIN_ROLE
keystone user-role-add --tenant-id $SERVICE_TENANT --user-id $CEILOMETER_USER --role-id $ADMIN_ROLE
keystone user-role-add --tenant-id $DEMO_TENANT --user-id $DEMO_USER --role-id $MEMBER_ROLE

# Create services
COMPUTE_SERVICE=$(keystone service-create \
  --name nova \
  --type compute \
  --description 'OpenStack Compute Service' | grep " id " | get_field 2)

VOLUME_SERVICE=$(keystone service-create \
  --name cinder \
  --type volume \
  --description 'OpenStack Volume Service' | grep " id " | get_field 2)

IMAGE_SERVICE=$(keystone service-create \
  --name glance \
  --type image \
  --description 'OpenStack Image Service' | grep " id " | get_field 2)

IDENTITY_SERVICE=$(keystone service-create \
  --name keystone \
  --type identity \
  --description 'OpenStack Identity' | grep " id " | get_field 2)

EC2_SERVICE=$(keystone service-create \
  --name ec2 \
  --type ec2 \
  --description 'OpenStack EC2 service' | grep " id " | get_field 2)

NETWORK_SERVICE=$(keystone service-create \
  --name neutron \
  --type network \
  --description 'OpenStack Networking service' | grep " id " | get_field 2)

HEAT_SERVICE=$(keystone service-create \
  --name heat \
  --type orchestration \
  --description 'HEAT Orchestration API' | grep " id " | get_field 2)

CEILOMETER_SERVICE=$(keystone service-create \
  --name ceilometer \
  --type metering \
  --description 'Ceilometer Telemetry Service' | grep " id " | get_field 2)


# Create endpoints
keystone endpoint-create \
  --region $KEYSTONE_REGION \
  --service-id $COMPUTE_SERVICE \
  --publicurl 'http://'"$HOST_IP"':8774/v2/$(tenant_id)s' \
  --adminurl 'http://'"$HOST_IP"':8774/v2/$(tenant_id)s' \
  --internalurl 'http://'"$HOST_IP"':8774/v2/$(tenant_id)s'

keystone endpoint-create \
  --region $KEYSTONE_REGION \
  --service-id $VOLUME_SERVICE \
  --publicurl 'http://'"$HOST_IP"':8776/v1/$(tenant_id)s' \
  --adminurl 'http://'"$HOST_IP"':8776/v1/$(tenant_id)s' \
  --internalurl 'http://'"$HOST_IP"':8776/v1/$(tenant_id)s'

keystone endpoint-create \
  --region $KEYSTONE_REGION \
  --service-id $IMAGE_SERVICE \
  --publicurl 'http://'"$HOST_IP"':9292' \
  --adminurl 'http://'"$HOST_IP"':9292' \
  --internalurl 'http://'"$HOST_IP"':9292'

keystone endpoint-create \
  --region $KEYSTONE_REGION \
  --service-id $IDENTITY_SERVICE \
  --publicurl 'http://'"$HOST_IP"':5000/v2.0' \
  --adminurl 'http://'"$HOST_IP"':35357/v2.0' \
  --internalurl 'http://'"$HOST_IP"':5000/v2.0'

keystone endpoint-create \
  --region $KEYSTONE_REGION \
  --service-id $EC2_SERVICE \
  --publicurl 'http://'"$HOST_IP"':8773/services/Cloud' \
  --adminurl 'http://'"$HOST_IP"':8773/services/Admin' \
  --internalurl 'http://'"$HOST_IP"':8773/services/Cloud'

keystone endpoint-create \
  --region $KEYSTONE_REGION \
  --service-id $NETWORK_SERVICE \
  --publicurl 'http://'"$HOST_IP"':9696/' \
  --adminurl 'http://'"$HOST_IP"':9696/' \
  --internalurl 'http://'"$HOST_IP"':9696/'

keystone endpoint-create \
  --region $KEYSTONE_REGION \
  --service-id $HEAT_SERVICE \
  --publicurl 'http://'"$HOST_IP"':8004/v1/%(tenant_id)s' \
  --adminurl 'http://'"$HOST_IP"':8004/v1/%(tenant_id)s' \
  --internalurl 'http://'"$HOST_IP"':8004/v1/%(tenant_id)s'

keystone endpoint-create \
  --region $KEYSTONE_REGION \
  --service-id $CEILOMETER_SERVICE \
  --publicurl 'http://'"$HOST_IP"':8777/' \
  --adminurl 'http://'"$HOST_IP"':8777/' \
  --internalurl 'http://'"$HOST_IP"':8777/'

