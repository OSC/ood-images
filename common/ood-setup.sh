#!/bin/bash

# Disable SELinux unless running in docker container or it's disabled
getenforce | grep -q Disabled
if [ ! -f /.dockerenv -a $? -ne 0 ]; then
    setenforce 0
    sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/sysconfig/selinux
    sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config
fi

# Add user to system and apache basic auth
groupadd ood
useradd --create-home --gid ood ood
echo -n "ood" | passwd --stdin ood

source /etc/os-release
if [ "$VERSION_ID" = "8" ]; then
    htpasswd -b -c /etc/httpd/.htpasswd ood ood
else
    scl enable httpd24 -- htpasswd -b -c /opt/rh/httpd24/root/etc/httpd/.htpasswd ood ood
fi

# Misc
mkdir -p /etc/ood/config/clusters.d
mkdir -p /etc/ood/config/apps/shell
