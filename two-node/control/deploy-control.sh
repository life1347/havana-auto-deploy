#!/bin/bash

../configure-system.sh

./install-mysql.sh

./initialize-mysql.sh

./install-rabbitmq.sh

./install-keystone.sh

./configure-keystone.sh

./initialize-keystone.sh

./install-glance.sh

./configure-glance.sh

./initialize-glance.sh

./install-cinder.sh

./configure-cinder.sh

./install-dashboard.sh

#./install-neutron.sh

#./configure-neutron.sh

./install-compute.sh

./configure-compute.sh

./install-heat.sh

./configure-heat.sh

#./install-ceilometer.sh

#./configure-ceilometer.sh
