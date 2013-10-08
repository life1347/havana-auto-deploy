#!/bin/bash

password='swordfish'

echo ''
echo 'Creating databases ...'
echo ''

mysql -u root -p <<EOF
CREATE DATABASE nova;
GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'localhost' IDENTIFIED BY '$password';
CREATE DATABASE cinder;
GRANT ALL PRIVILEGES ON cinder.* TO 'cinder'@'localhost' IDENTIFIED BY '$password';
CREATE DATABASE glance;
GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'localhost' IDENTIFIED BY '$password';
CREATE DATABASE keystone;
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' IDENTIFIED BY '$password';
CREATE DATABASE quantum;
GRANT ALL PRIVILEGES ON quantum.* TO 'quantum'@'localhost' IDENTIFIED BY '$password';
GRANT ALL PRIVILEGES ON quantum.* TO 'quantum'@'10.10.10.9' IDENTIFIED BY '$password';
GRANT ALL PRIVILEGES ON quantum.* TO 'quantum'@'10.10.10.11' IDENTIFIED BY '$password';
FLUSH PRIVILEGES;
EOF

echo ''
echo 'Getting list of databases ...'
echo ''

mysql -u root -p <<EOF
show databases;
EOF
