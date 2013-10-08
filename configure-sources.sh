#!/bin/bash

apt-get -y install ubuntu-cloud-keyring

cat << EOF > /etc/apt/sources.list.d/cloud-archive.list
# The primary updates archive that users should be using
deb http://ubuntu-cloud.archive.canonical.com/ubuntu precise-updates/havana main

# Public -proposed archive mimicking the SRU process for extended testing.
# Packages should bake here for at least 7 days. 
#deb  http://ubuntu-cloud.archive.canonical.com/ubuntu precise-proposed/havana main
EOF

#cat << EOF > /etc/apt/preferences.d/local.pref
#Package: openvswitch-*
#Pin: release o=Ubuntu
#Pin-Priority: 501
#
#Package: novnc
#Pin: release o=Ubuntu
#Pin-Priority: 501
#EOF

apt-get update

apt-get -y install python-dev python-setuptools

easy_install pip

apt-get -y install ntp
