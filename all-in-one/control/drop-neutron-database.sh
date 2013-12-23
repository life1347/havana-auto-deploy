#!/bin/bash

source ../openrc

mysql -uroot -p$MYSQL_PASSWORD << EOF
drop database neutron;
create database neutron;
grant all privileges on neutron.* to 'neutron'@'$HOST_IP' identified by '$MYSQL_PASSWORD';
flush privileges;
EOF

./restart-os-services.sh neutron