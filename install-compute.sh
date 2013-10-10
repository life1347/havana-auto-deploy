#!/bin/bash

apt-get install --yes nova-api nova-cert nova-common nova-conductor \
    nova-scheduler python-nova python-novaclient nova-consoleauth \
    novnc nova-novncproxy

apt-get install --yes nova-compute-kvm

pip install --upgrade websockify
