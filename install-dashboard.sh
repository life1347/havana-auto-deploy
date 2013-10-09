#!/bin/bash

apt-get install -y openstack-dashboard memcached python-memcache

apt-get remove --purge openstack-dashboard-ubuntu-theme

service apache2 restart
