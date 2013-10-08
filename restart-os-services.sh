#!/bin/bash

nova_services='
nova-api
nova-cert
nova-compute
nova-conductor
nova-consoleauth
nova-novncproxy
nova-scheduler
'

neutron_services='
neutron-dhcp-agent
neutron-metadata-agent
neutron-server
neutron-l3-agent
neutron-plugin-openvswitch-agent
'

restart_services() {
    for service in "$@" ; do
        echo ''
        echo "Restarting service $service ..."
        service $service restart
    done
    echo '' 
}

case $1 in
  'all')
    echo "Not implemented yet"
  ;;
  'nova')
    restart_services $nova_services
  ;;
  'neutron')
    restart_services $neutron_services
  ;;
  *)
    echo "Wrong group name"
  ;;
esac
