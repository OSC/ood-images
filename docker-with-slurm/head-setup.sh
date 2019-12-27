#!/bin/bash
set -e

yum -y install mailx openssh-server
install -D -m644 /opt/slurm/etc/slurmctld.service /etc/systemd/system/
install -D -m644 /opt/slurm/etc/slurmd.service /etc/systemd/system/
install -d -o slurm -g slurm /var/spool/slurm
install -d -o slurm -g slurm /var/log/slurm
install -d -o slurm -g slurm /var/run/slurm
install -d /var/spool/slurmd
/usr/sbin/sshd-keygen
sed -i 's/^PasswordAuthentication.*/PasswordAuthentication yes/g' /etc/ssh/sshd_config
cp /build/launch-head /usr/local/sbin/launch

yum clean all && rm -rf /var/cache/yum/*
