#!/bin/bash

./configure-system.sh

./install-neutron.sh

./configure-neutron.sh

./install-compute.sh

./configure-compute.sh
