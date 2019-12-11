#!/bin/bash
set -x

add_operator() {
  SGE_ROOT=/opt/sge /opt/sge/bin/lx-amd64/qconf -ao "$1"
}

add_q() {
    SGE_ROOT=/opt/sge /opt/sge/bin/lx-amd64/qconf -Aq "$1"
}

export -f add_operator
export -f add_q

yum install -y yum-plugin-copr
yum copr enable -y loveshack/SGE
export LIBCGROUP="libcgroup-devel"
yum install -y gridengine gridengine-qmaster gridengine-qmon gridengine-execd munge munge-devel

# Install munge
install -o munge -g munge -m 0600 /vagrant/munge.key /etc/munge/munge.key
systemctl enable munge
systemctl start munge

(
  cd "/opt/sge" || exit 1
  /opt/sge/install_qmaster -munge -auto /vagrant/sge.conf
  /opt/sge/install_execd -munge -auto /vagrant/sge.conf
  cp -f /opt/sge/default/common/settings.sh /etc/profile.d/
)

add_operator "vagrant"
add_operator "ood"

add_q /vagrant/all.q

echo 'gridengine ready'
