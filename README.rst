Havana Multi Node Deploy scripts
####################

This repo is forked from dmitry-teselkin's havana-from-packages, and I changed it to multi node auto-deploy scripts.

If meet problems during deployment, it welcome to ask for any help. 

**NOTE: This guide describes installation of MULTI NODE OPENSTACK.**

::

    git clone https://github.com/life1347/havana-from-packages.git
..



Prerequisites
=============

* Ubuntu Server 12.04.3 x64 with 3.2 kernel 

Configure the system
====================

**Configured**

* set up nodes information in openrc(EVERY node should set up before installaion start)

::
    $ cd havana-from-packages
    $ vim openrc
..

Installation
============

**Deployment**

* change current directory to type of node you want

**Control node**
::
    $ cd ./control; ./deploy-control.sh
..

**Network node**
::
    $ cd ./network; ./deploy-network.sh
..

**Compute node**
::
    $ cd ./compute; ./deploy-compute.sh
..

YAHOO!!!!!!!!!
==============
YOU OWN OPENSTACK IS THERE!
