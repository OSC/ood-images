#!/bin/bash

unset HISTFILE

package-cleanup --oldkernels --count=1

yum clean all

rm -rf /var/cache/*
rm -rf /tmp/*
rm -rf /var/tmp/*

rm -f /etc/udev/rules.d/70*.rules
rm -f /etc/ssh/*key*

rm -rf /root/.npm
rm -f /root/.bash_history
rm -rf /root/.ssh
rm -f /root/*.cfg
rm -f /root/*log

sed -i -r '/^(HWADDR|UUID)=/d' /etc/sysconfig/network-scripts/ifcfg-eth0

cat > /etc/resolv.conf <<EOF
nameserver 8.8.8.8
EOF

service rsyslog stop
find /var/log -type f -name '*.old' -exec rm -f {} \;
find /var/log -type f -exec truncate {} --size 0 \;
