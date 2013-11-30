#!/bin/bash

source ./openrc

echo ''
echo 'Dropping databases ...'
echo ''

mysql -u root -p$MYSQL_PASSWORD <<EOF
DROP DATABASE nova;
DROP DATABASE cinder;
DROP DATABASE glance;
DROP DATABASE keystone;
DROP DATABASE quantum;
DROP DATABASE heat;
EOF

echo ''
echo 'Creating databases ...'
echo ''

mysql -u root -p$MYSQL_PASSWORD <<EOF
CREATE DATABASE nova;
GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
CREATE DATABASE cinder;
GRANT ALL PRIVILEGES ON cinder.* TO 'cinder'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
CREATE DATABASE glance;
GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
CREATE DATABASE keystone;
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
CREATE DATABASE quantum;
GRANT ALL PRIVILEGES ON quantum.* TO 'quantum'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
CREATE DATABASE heat;
GRANT ALL PRIVILEGES ON heat.* TO 'heat'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
FLUSH PRIVILEGES;
EOF

echo ''
echo 'Getting list of databases ...'
echo ''

mysql -u root -p$MYSQL_PASSWORD <<EOF
show databases;
EOF
