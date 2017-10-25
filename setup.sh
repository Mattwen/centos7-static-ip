#!/bin/bash

# Script that prompts user questions for static IP address set up

# Uncomment for full system update
# su -c 'yum update'
echo -n "Enter desired hostname: "
read hostname
hostnamectl set-hostname $hostname

hostname=$(hostname)
gateway="10.0.0.1"
netmask="255.255.254.0"
broadcast="10.0.1.255"

cat >/etc/sysconfig/network <<EOL
NETWORKING=yes
HOSTNAME=$hostname
GATEWAY=$gateway
EOL

sed -i.bak 's/dhcp/static/' /etc/sysconfig/network-scripts/ifcfg-ens192 /etc/sysconfig/network-scripts/ifcfg-ens192
echo -n "Enter desired IP Address for this machine: "
read ipaddr
#echo -n "Enter netmask: "
#read netmask
#echo -n "Enter Broadcast Address: "
#read broadcast

cat >>/etc/sysconfig/network-scripts/ifcfg-ens192 <<EOL
IPADDR=${ipaddr}
NETMASK=${netmask}
BROADCAST=${broadcast}
GATEWAY=${gateway}
DNS1=10.0.0.19
DNS2=10.0.0.20
EOL

service network restart
