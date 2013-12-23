#/bin/bash

apt-get install --yes rabbitmq-server

/usr/lib/rabbitmq/bin/rabbitmq-plugins enable rabbitmq_management

service rabbitmq-server restart

netstat -ntolp | grep beam
