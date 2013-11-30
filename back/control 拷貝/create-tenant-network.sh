#!/bin/bash

source ./openrc

router_name='public-router'
tenant_name='demo'
tenant_net_name="${tenant_name}-net"
tenant_net_range="***.***.***.***/***"
tenant_subnet_name="${tenant_name}-subnet"
dns_servers_list="***.***.***.*** ***.***.***.***"

tenant_id=$(keystone tenant-list | awk "/$tenant_name/ {print \$2}")

echo "tenant_id = '$tenant_id'"

router_id=$(neutron router-list | awk "/$router_name/ {print \$2}")

echo "router_id = '$router_id'"

tenant_net_id=$(neutron net-create \
  --tenant-id $tenant_id \
  $tenant_net_name | awk "/ id / {print \$4}")

echo "tenant_net_id = '$tenant_net_id'"

tenant_subnet_id=$(neutron subnet-create \
  $tenant_net_id $tenant_net_range \
  --tenant-id $tenant_id \
  --dns_nameservers list=true $dns_servers_list \
  --name $tenant_subnet_name | awk "/ id / {print \$4}")

echo "tenant_subnet_id = '$tenant_subnet_id'"

neutron router-interface-add $router_id $tenant_subnet_id
