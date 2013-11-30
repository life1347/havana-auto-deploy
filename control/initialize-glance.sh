#!/bin/bash

source ../openrc

wget http://download.cirros-cloud.net/0.3.1/cirros-0.3.1-x86_64-disk.img

glance image-create --name "CirrOS 0.3.1" \
  --disk-format qcow2 \
  --container-format bare \
  --is-public true < cirros-0.3.1-x86_64-disk.img
