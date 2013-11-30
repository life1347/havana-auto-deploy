#!/bin/bash

source ../openrc

TENANT_NAME="service"
TENANT_NETWORK_NAME="public"
TENANT_SUBNET_NAME="${TENANT_NETWORK_NAME}-subnet"
TENANT_ROUTER_NAME="${TENANT_NETWORK_NAME}-router"

NETWORK_RANGE="***.***.***.***/***"
NETWORK_GATEWAY="***.***.***.***"

TENANT_ID=$(keystone tenant-list | awk "/$TENANT_NAME/ {print \$2}")

echo "TENANT_ID = '$TENANT_ID'"

TENANT_NET_ID=$(neutron net-create \
  --tenant_id $TENANT_ID $TENANT_NETWORK_NAME \
  --provider:network_type flat \
  --provider:physical_network physnet1 \
  --router:external=True | awk "/ id / {print \$4}")

echo "TENANT_NET_ID = '$TENANT_NET_ID'"

TENANT_SUBNET_ID=$(neutron subnet-create \
  $TENANT_NET_ID $NETWORK_RANGE \
  --tenant_id $TENANT_ID \
  --ip_version 4 \
  --name $TENANT_SUBNET_NAME \
  --gateway $NETWORK_GATEWAY \
  --allocation_pool start=***.***.***.***,end=***.***.***.*** \
  --enable_dhcp False | awk "/ id / {print \$4}")

echo "TENANT_SUBNET_ID = '$TENANT_SUBNET_ID'"

ROUTER_ID=$(neutron router-create \
  --tenant_id $TENANT_ID \
  $TENANT_ROUTER_NAME | awk "/ id / {print \$4}")

echo "ROUTER_ID = '$ROUTER_ID'"

neutron router-gateway-set $ROUTER_ID $TENANT_NET_ID
