#!/bin/bash

source ../openrc

debconf-set-selections <<< "mysql-server mysql-server/root_password password $MYSQL_PASSWORD"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $MYSQL_PASSWORD"

apt-get install --yes python-mysqldb mysql-server

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mysql/my.cnf

service mysql restart
