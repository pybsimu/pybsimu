#!/bin/bash
echo "export LD_LIBRARY_PATH=/home/ubuntu/lib" >> ~/.bashrc
echo "export PKG_CONFIG_PATH=/home/ubuntu/lib/pkgconfig" >> ~/.bashrc
# when using WSL get this ip from ipconfig look for vEthernet (WSL)
echo "export DISPLAY=172.22.160.1:0.0" >> ~/.bashrc

# Run this script first, then load it all up from .bashrc, as follows:
#
# $ ibsimu_config/ibsimu_config.sh
# $ . ~/.bashrc
