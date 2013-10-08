Havana From Packages
####################

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
    #deb  http://ubuntu-cloud.archive.canonical.com/ubuntu precise-proposed/havana main
..

* Configure package pinning rules

**/etc/apt/preferences/local.pref**

::

    Package: openvswitch-*
    Pin: release o=Ubuntu
    Pin-Priority: 501

    Package: novnc
    Pin: release o=Ubuntu
    Pin-Priority: 501
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
