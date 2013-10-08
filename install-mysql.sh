#!/bin/bash

apt-get install -y python-mysqldb mysql-server

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mysql/my.cnf

service mysql restart
