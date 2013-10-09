Havana From Packages
####################

::

    git clone https://github.com/dmitry-teselkin/havana-from-packages.git
..

Prerequisites
=============

* Ubuntu Server 12.04.3 x64

Configure software sources
==========================

Add **CloudArchive** repository:

**Link**

::

    https://wiki.ubuntu.com/ServerTeam/CloudArchive
..

* Add the *ubuntu-cloud-keyring* package:

::

    ># apt-get install ubuntu-cloud-keyring
..

* Add repository into apt sources

**/etc/apt/sources.list.d/cloud-archive.list**

::

    # The primary updates archive that users should be using
    deb http://ubuntu-cloud.archive.canonical.com/ubuntu precise-updates/havana main

    # Public -proposed archive mimicking the SRU process for extended testing.
    # Packages should bake here for at least 7 days. 
    deb http://ubuntu-cloud.archive.canonical.com/ubuntu precise-proposed/havana main
..

* (**SKIP THIS**) Configure package pinning rules

**/etc/apt/preferences/local.pref**

::

    #Package: openvswitch-*
    #Pin: release o=Ubuntu
    #Pin-Priority: 501

    #Package: novnc
    #Pin: release o=Ubuntu
    #Pin-Priority: 501
..

* Update

::

    ># apt-get update
..

Install OpenStack
=================

In general, installation steps are the same as in the official guide "How to install OpenStack Grizzly on Ubuntu 12.04".

Install Controller part
-----------------------


* Edit */etc/sysctl.conf*:

::

    net.ipv4.conf.all.rp_filter = 0
    net.ipv4.conf.default.rp_filter = 0
..

* Apply the sysctl settings:

::

    ># sysctl -e -p /etc/sysctl.conf
..

* Install ntp

::

    ># apt-get install -y ntp
..

Install MySQL
-------------

::

    ># apt-get install -y python-mysqldb mysql-server
..


::

    ># dd if=/dev/zero of=/opt/cinder-volumes.img bs=100 count=100M
    ># losetup /dev/loop0 /opt/cinder-columes.img
..

::

    ># sfdisk /dev/loop0 << EOF
    ,,8e,,
    EOF
..

::

    ># pvcreate /dev/loop0
    ># vgcreate cinder-volumes /dev/loop0
..

Install RabbitMQ Server
-----------------------

::

    ./install-rabbitmq-server.sh
..

Install Keystone Service
------------------------

::

    ./install-keystone.sh
..

::

    source openrc
    ./populate-keystone-data.sh
..

Install Image Service
---------------------

::

    ./install-glance.sh
..

::

    ./glance-import-image.sh
..

Install Compute part
--------------------




::

    check the --libvirt-type if it is "kvm" then
    change it to --libvirt-type=qemu in /etc/nova/nova-compute.conf
    and reboot the machine
    your bug will get resolved
..


Install Heat
------------

* Install Heat

::

    apt-get -y install heat-api heat-api-cfn heat-api-cloudwatch \
        heat-common heat-engine python-heat python-heatclient
..

* Configure /etc/heat/api-paste.ini

::

    --- api-paste.ini.orig  2013-10-08 10:07:11.672155268 -0400
    +++ api-paste.ini   2013-10-08 10:46:02.708196472 -0400
    @@ -77,6 +77,13 @@
     # Auth middleware that validates token against keystone
     [filter:authtoken]
     paste.filter_factory = heat.common.auth_token:filter_factory
    +auth_host = 127.0.0.1
    +auth_port = 35357
    +auth_protocol = http
    +auth_uri = http://127.0.0.1:5000/v2.0
    +admin_tenant_name = admin
    +admin_user = admin
    +admin_password = swordfish
     
    # Auth middleware that validates username/password against keystone
     [filter:authpassword]
..

* Configure /etc/heat/heat.conf

::

    --- heat.conf.orig  2013-10-08 10:08:00.071029682 -0400
    +++ heat.conf   2013-10-08 10:35:13.874480898 -0400
    @@ -137,10 +137,12 @@
     # Print debugging output (set logging level to DEBUG instead
     # of default WARNING level). (boolean value)
     #debug=false
    +debug=true
     
     # Print more verbose output (set logging level to INFO instead
     # of default WARNING level). (boolean value)
     #verbose=false
    +verbose=true
     
     # Log output to standard error (boolean value)
     #use_stderr=true
    @@ -203,6 +205,7 @@
     # (Optional) The base directory used for relative --log-file
     # paths (string value)
     #log_dir=<None>
    +log_dir=/var/log/heat
     
     # Use syslog for logging. (boolean value)
     #use_syslog=false
..

Bugs
====

* https://review.openstack.org/#/c/48749/2/heat/engine/resources/neutron/port.py
* https://ask.openstack.org/en/question/4222/horizon-console-displays-blank-screen-with-message-novnc-ready-native-websockets-canvas-rendering/
