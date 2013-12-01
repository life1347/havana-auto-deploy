#!/bin/bash

apt-get install --yes \
	neutron-server

service neutron-server restart
