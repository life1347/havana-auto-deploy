#!/bin/bash

apt-get install -y nova-api nova-cert nova-common nova-conductor \
    nova-scheduler python-nova python-novaclient nova-consoleauth \
    novnc nova-novncproxy

pip install --upgrade websockify
