#!/bin/bash
set -xe

add_operator() {
  SGE_ROOT=/opt/sge /opt/sge/bin/lx-amd64/qconf -ao "$1"
}

export -f add_operator

yum install -y epel-release yum-plugin-copr
yum install -y munge munge-devel
install -o munge -g munge -m 0600 /vagrant/munge.key /etc/munge/munge.key
systemctl enable munge
systemctl start munge

yum copr enable -y loveshack/SGE
yum install -y gridengine gridengine-qmaster gridengine-qmon gridengine-execd

(
  cd "/opt/sge" || exit 1
  if [[ $(hostname) == "ood" ]]; then
    /opt/sge/install_qmaster -munge -auto /vagrant/sge.conf
    add_operator "vagrant"
    add_operator "ood"
  else
    /opt/sge/install_qmaster -munge -auto /vagrant/sge.conf
    /opt/sge/install_execd -munge -auto /vagrant/sge.conf
    add_operator "vagrant"
    add_operator "ood"
  fi
)

echo 'gridengine ready'