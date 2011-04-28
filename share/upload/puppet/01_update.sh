#!/bin/bash
host_file="/etc/hosts";
master_ip=$(grep puppet $host_file | awk '{print $1}');
if [ "$master_ip" != "$real_master" ]; then
   sudo sed -i '/puppet/d' $host_file
   sudo sed -i "1a\ $real_master puppet" $host_file
fi
# [ -e /etc/puppet/ssl ] && sudo rm -rf /etc/puppet/ssl
[ -e /etc/tinc ] && sudo chmod -R 777 /etc/tinc

gembin_path=`gem env | grep "EXECUTABLE DIRECTORY" | awk '{print $4}'`

no_puppetuser=`id puppet`
[ -z "$no_puppetuser" ] && sudo $gembin_path/puppetmasterd --mkuser

sudo $gembin_path/puppetd --test --verbose
