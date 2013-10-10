#/bin/bash

apt-get install --yes rabbitmq-server

#rabbitmqctl change_password guest swordfish

/usr/lib/rabbitmq/bin/rabbitmq-plugins enable rabbitmq_management

cat << EOF >> /etc/rabbitmq/rabbitmq.conf.d/rabbitmq-node-ip-address
RABBITMQ_NODE_IP_ADDRESS=0.0.0.0
EOF

service rabbitmq-server restart

netstat -ntolp | grep beam
