#!/bin/bash

set -e

# Force httpd24 service to use scl ruby
sed -i 's/^HTTPD24_HTTPD_SCLS_ENABLED=.*/HTTPD24_HTTPD_SCLS_ENABLED="httpd24 rh-ruby22"/g' /opt/rh/httpd24/service-environment
# Disable SELinux unless running in docker container or it's disabled
getenforce | grep -q Disabled
if [ ! -f /.dockerenv -a $? -ne 0 ]; then
    setenforce 0
    sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/sysconfig/selinux
fi

# Install ood-portal-generator
mkdir -p /opt/ood/src
cd /opt/ood/src
scl enable git19 -- git clone https://github.com/OSC/ood-portal-generator.git
cd ood-portal-generator
scl enable git19 -- git reset --hard v0.3.1
scl enable rh-ruby22 -- rake install

# Add user to system and apache basic auth
groupadd --gid 1000 ood
useradd --create-home --uid 1000 --gid ood ood
echo -n "ood" | passwd --stdin ood
scl enable httpd24 -- htpasswd -b -c /opt/rh/httpd24/root/etc/httpd/.htpasswd ood ood

# Install mod_ood_proxy
cd /opt/ood/src
scl enable git19 -- git clone https://github.com/OSC/mod_ood_proxy.git
cd mod_ood_proxy
scl enable git19 -- git reset --hard v0.2.0
scl enable rh-ruby22 -- rake install

# Install nginx_stage
cd /opt/ood/src
scl enable git19 -- git clone https://github.com/OSC/nginx_stage.git
cd nginx_stage
scl enable git19 -- git reset --hard v0.2.1
scl enable rh-ruby22 -- rake install

# Configure nginx_stage
sed -i 's/^#exec scl/exec scl/g' /opt/ood/nginx_stage/bin/ood_ruby
cat > /etc/sudoers.d/nginx_stage <<EOF
Defaults:apache !requiretty,!authenticate
apache ALL=(ALL) NOPASSWD: /opt/ood/nginx_stage/sbin/nginx_stage
EOF

# Install ood_auth_map
cd /opt/ood/src
scl enable git19 -- git clone https://github.com/OSC/ood_auth_map.git
cd ood_auth_map
scl enable git19 -- git reset --hard v0.0.3
scl enable rh-ruby22 -- rake install

# App installations
mkdir -p /etc/ood/config/clusters.d
mkdir -p /var/www/ood/apps/sys
# dashboard
cd /var/www/ood/apps/sys
scl enable git19 -- git clone https://github.com/OSC/ood-dashboard.git dashboard
cd dashboard
scl enable git19 -- git reset --hard v1.10.0
scl enable rh-ruby22 -- bin/bundle install --path=vendor/bundle
scl enable rh-ruby22 nodejs010 -- bin/rake assets:precompile RAILS_ENV=production
scl enable rh-ruby22 nodejs010 -- bin/rake tmp:clear

# shell
cd /var/www/ood/apps/sys
scl enable git19 -- git clone https://github.com/OSC/ood-shell.git shell
cd shell
scl enable git19 -- git reset --hard v1.1.2
scl enable git19 nodejs010 -- npm install

# files
cd /var/www/ood/apps/sys
scl enable git19 -- git clone https://github.com/OSC/ood-fileexplorer.git files
cd files
scl enable git19 -- git reset --hard v1.3.1
scl enable git19 nodejs010 -- npm install

# file-editor
cd /var/www/ood/apps/sys
scl enable git19 -- git clone https://github.com/OSC/ood-fileeditor file-editor
cd file-editor
scl enable git19 -- git reset --hard v1.2.3
scl enable rh-ruby22 -- bin/bundle install --path=vendor/bundle
scl enable rh-ruby22 nodejs010 -- bin/rake assets:precompile RAILS_ENV=production
scl enable rh-ruby22 nodejs010 -- bin/rake tmp:clear

# activejobs
cd /var/www/ood/apps/sys
scl enable git19 -- git clone https://github.com/OSC/ood-activejobs activejobs
cd activejobs
scl enable git19 -- git reset --hard v1.3.1
scl enable rh-ruby22 -- bin/bundle install --path=vendor/bundle
scl enable rh-ruby22 nodejs010 -- bin/rake assets:precompile RAILS_ENV=production
scl enable rh-ruby22 nodejs010 -- bin/rake tmp:clear

# myjobs
cd /var/www/ood/apps/sys
scl enable git19 -- git clone https://github.com/OSC/ood-myjobs myjobs
cd myjobs
scl enable git19 -- git reset --hard v2.1.2
scl enable rh-ruby22 git19 -- bin/bundle install --path=vendor/bundle
scl enable rh-ruby22 nodejs010 -- bin/rake assets:precompile RAILS_ENV=production
scl enable rh-ruby22 nodejs010 -- bin/rake tmp:clear
