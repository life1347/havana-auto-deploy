#!/bin/bash

wget http://download.cirros-cloud.net/0.3.1/cirros-0.3.1-x86_64-disk.img

glance image-create --is-public true --disk-format qcow2 --container-format bare --name "CirrOS 0.3.1" < cirros-0.3.1-x86_64-disk.img
