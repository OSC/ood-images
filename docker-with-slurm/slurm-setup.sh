#!/bin/bash
set -e

yum -y install epel-release
yum -y install munge munge-devel libcgroup-devel curl bzip2 @buildsys-build \
  readline-devel numactl-devel pam-devel glib2-devel hwloc-devel openssl-devel curl-devel \
  python3
cp /build/munge.key /etc/munge/munge.key
chown munge:munge /etc/munge/munge.key
chmod 0600 /etc/munge/munge.key
curl -o /tmp/slurm-20.02.1.tar.bz2 https://download.schedmd.com/slurm/slurm-20.02.1.tar.bz2
pushd /tmp
tar xf slurm-20.02.1.tar.bz2
pushd slurm-20.02.1
./configure --prefix=/opt/slurm --sysconfdir=/opt/slurm/etc
make -j4
make install
mkdir /opt/slurm/etc
install -D -m644 ./etc/slurmctld.service /opt/slurm/etc/
install -D -m644 ./etc/slurmd.service /opt/slurm/etc/
cp /build/slurm.sh /etc/profile.d/slurm.sh
cp /build/slurm.conf /opt/slurm/etc/slurm.conf
groupadd -r slurm
useradd -r -g slurm -d /var/spool/slurm -s /sbin/nologin slurm

rm -rf /tmp/slurm*
yum clean all && rm -rf /var/cache/yum/*
