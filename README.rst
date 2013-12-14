Havana Multi Node Deploy scripts
####################

**NOTE: This guide describes installation of MULTI NODE OPENSTACK.**

This repo is forked from dmitry-teselkin's havana-from-packages, and I changed it to multi node auto deploy scripts.

If meet problems during deployment, it welcome to ask for any help. 

::

    git clone https://github.com/life1347/havana-multinode-auto-deploy.git
..


Prerequisites
=============

* Ubuntu Server 12.04.3 x64 with 3.2 kernel 
* control node - 2 network interfaces
* network node - 3 network interfaces
* compute node - 2 network interfaces

Configure the system
====================

**Configured**
::
    # set up nodes information in openrc(EVERY node should set up before deployment)
    $ cd havana-from-packages; vim openrc
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

**NOTE: creds(credentials), which contains auth information, would be created same level of directory of openrc at control node**

HELLO WORLD, YAHOO!!!!!!!!!
==============
**Reference**

* https://github.com/dmitry-teselkin/havana-from-packages
* http://docs.openstack.org/havana/install-guide/install/apt/content/
