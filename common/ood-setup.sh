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

# Misc
mkdir -p /etc/ood/config/clusters.d
mkdir -p /etc/ood/config/apps/shell

# Set necessary changes for dex to work where local system is not host running OnDemand
PORT=${1:-8080}
cat > /etc/ood/config/ood_portal.yml <<EOF
listen_addr_port: ${PORT}
port: ${PORT}
servername: localhost
EOF
/opt/ood/ood-portal-generator/sbin/update_ood_portal
