# -*- mode: ruby -*-
# vi: set ft=ruby :

def install_deps!(node)
  node.vm.provision "shell", inline: "cp -f /vagrant/hosts /etc/hosts"
  deps = [
    'java-1.8.0-openjdk',
    'ed',

    # * purely for convenience
    'the_silver_searcher',
    'vim',
    'zip'
  ]
  node.vm.provision "shell", inline: "yum install -y #{deps.join(' ')}"
end

def install_lsf!(node)
  node.vm.provision "shell", inline: <<~SHELL
    cd /vagrant || exit 1
    tar xzf lsfsce10.2.0.6-x86_64.tar.gz
    cd lsfsce10.2.0.6-x86_64/lsf || exit 1
    tar xf lsf10.1_lsfinstall_linux_x86_64.tar.Z
    cd lsf10.1_lsfinstall || exit 1

    # Install
    /vagrant/lsfsce10.2.0.6-x86_64/lsf/lsf10.1_lsfinstall/lsfinstall -f /vagrant/install.config || exit 1

    cp -f /opt/lsf/conf/profile.lsf /etc/profile.d/lsf.sh

    # Ensure that LSF config available in default location
    cp -f /opt/lsf/10.1/conf/lsf.conf /etc/

    # Start
    /opt/lsf/10.1/install/hostsetup --top=/opt/lsf --boot=y --start=y
  SHELL
end

def add_ood_user!(node)
  node.vm.provision "shell", inline: <<-SHELL
    groupadd ood
    useradd --create-home --gid ood ood
    echo -n "ood" | passwd --stdin ood
  SHELL
end

Vagrant.configure(2) do |config|
  config.vm.box = "centos/7"
  config.vm.synced_folder ".", "/vagrant", type: "virtualbox"
  config.vm.synced_folder "./ood-home", "/home/ood", type: "virtualbox", mount_options: ["uid=1001","gid=1001"]

  config.vm.define "head", primary: false, autostart: true do |head|
    head.vm.network "private_network", ip: "10.0.0.101"
    head.vm.provision "shell", path: "head-setup.sh"
    head.vm.provision "shell", inline: "hostnamectl set-hostname head"
    head.vm.provision "shell", inline: "cp -f /vagrant/hosts /etc/hosts"

    install_deps!(head)
    install_lsf!(head)
  end

  config.vm.define "ood", primary: true, autostart: true do |ood|
    ood.vm.network "forwarded_port", guest: 80, host: 8080
    ood.vm.network "private_network", ip: "10.0.0.100"
    ood.vm.provision "shell", inline: <<-SHELL
      yum install -y epel-release centos-release-scl lsof sudo
      yum install -y https://yum.osc.edu/ondemand/latest/ondemand-release-web-latest-1-2.el7.noarch.rpm
      yum install -y ondemand
    SHELL
    ood.vm.provision "shell", path: "ood-setup.sh"
    ood.vm.provision "shell", inline: <<-SHELL
      systemctl enable httpd24-httpd
      systemctl start httpd24-httpd
      hostnamectl set-hostname ood
      cp -f /vagrant/hosts /etc/hosts
      cp -f /vagrant/lsf.yml /etc/ood/config/clusters.d/lsf.yml
    SHELL

    # LSF!
    install_deps!(ood)
    install_lsf!(ood)
  end
end

