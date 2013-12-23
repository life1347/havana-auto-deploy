#!/bin/bash

source ../openrc

echo ''
echo 'Dropping databases ...'
echo ''

mongo <<EOF
use ceilometer
db.dropDatabase()
EOF

mongo <<EOF
use ceilometer
db.addUser({ user: "ceilometer", pwd: "CEILOMETER_DBPASS", roles: ["readWrite", "dbAdmin"]})
EOF
