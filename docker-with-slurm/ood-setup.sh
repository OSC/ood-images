#!/bin/bash
set -e

yum install -y centos-release-scl https://yum.osc.edu/ondemand/latest/ondemand-release-web-latest-1-6.noarch.rpm
yum install -y ondemand
scl enable httpd24 -- htpasswd -b -c /opt/rh/httpd24/root/etc/httpd/.htpasswd ood ood
mkdir -p /etc/ood/config/clusters.d
mkdir -p /etc/ood/config/apps/shell
echo "DEFAULT_SSHHOST=head" > /etc/ood/config/apps/shell/env
cp /build/launch-ood /usr/local/sbin/launch

yum clean all && rm -rf /var/cache/yum/*
