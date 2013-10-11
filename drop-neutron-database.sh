#!/bin/bash

source ./openrc

mysql -uroot -p$MYSQL_PASSWORD << EOF
drop database quantum;
create database quantum;
grant all privileges on quantum.* to 'quantum'@'localhost' identified by '$MYSQL_PASSWORD';
flush privileges;
EOF

./restart-os-services.sh neutron
