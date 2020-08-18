#!/bin/bash
set -e

yum install -y centos-release-scl https://yum.osc.edu/ondemand/latest/ondemand-release-web-latest-1-6.noarch.rpm
yum install -y ondemand ondemand-dex
mkdir -p /etc/ood/config/clusters.d
mkdir -p /etc/ood/config/apps/shell
echo "DEFAULT_SSHHOST=head" > /etc/ood/config/apps/shell/env
PORT=${1:-8080}
cat > /etc/ood/config/ood_portal.yml <<EOF
listen_addr_port: ${PORT}
port: ${PORT}
servername: localhost
oidc_settings:
  # Needed when not using HTTPS in Chrome
  OIDCCookieSameSite: 'On'
EOF
/opt/ood/ood-portal-generator/sbin/update_ood_portal
cp /build/launch-ood /usr/local/sbin/launch

yum clean all && rm -rf /var/cache/yum/*
