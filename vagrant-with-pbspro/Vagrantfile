# -*- mode: ruby -*-
# vi: set ft=ruby :

def install_deps!(node)
  node.vm.provision "shell", inline: "cp -f /vagrant/hosts /etc/hosts"
  deps = [
    'expat',
    'hwloc',
    'libedit',
    'libical',
    'libICE',
    'libSM',
    'perl-Env',
    'perl-Switch',
    'postgresql-contrib',
    'postgresql-server',
    'python',
    'sendmail',
    'sudo',
    'tcl',
    'tk',
    'unzip',

    # * purely for convenience
    'the_silver_searcher',
    'vim',
    'zip'
  ]
  node.vm.provision "shell", inline: "yum install -y #{deps.join(' ')}"
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

  config.vm.define "ood", primary: true, autostart: true do |ood|
    ood.vm.network "forwarded_port", guest: 80, host: 8080
    ood.vm.network "private_network", ip: "10.0.0.100"
    ood.vm.provision "shell", inline: <<-SHELL
      yum install -y epel-release centos-release-scl lsof sudo
      yum install -y https://yum.osc.edu/ondemand/latest/ondemand-release-web-latest-1-2.el7.noarch.rpm
      yum install -y ondemand
    SHELL
    ood.vm.provision "shell", path: "ood-setup.sh"
    ood.vm.provision "shell", inline: "systemctl enable httpd24-httpd"
    ood.vm.provision "shell", inline: "systemctl start httpd24-httpd"
    ood.vm.provision "shell", inline: "hostnamectl set-hostname ood"
    ood.vm.provision "shell", inline: "cp -f /vagrant/hosts /etc/hosts"
    ood.vm.provision "shell", inline: "cp -f /vagrant/pbs.yml /etc/ood/config/clusters.d/pbs.yml"

    # PBSPro!
    install_deps!(ood)
    ood.vm.provision "shell", inline: <<-SHELL
      # Note that this will only be done during the OOD constructor
      # If other VMs fail to build check for the existence of /vagrant/pbspro_19.1.1.centos7.zip
      if [[ ! -e /vagrant/pbspro_19.1.1.centos7.zip ]]; then
        (
          cd /vagrant || exit 1
          curl -L https://github.com/PBSPro/pbspro/releases/download/v19.1.1/pbspro_19.1.1.centos7.zip -o pbspro_19.1.1.centos7.zip
          unzip pbspro_19.1.1.centos7.zip
        )
      fi

      (cd /vagrant/pbspro_19.1.1.centos7 && rpm -i pbspro-client-19.1.1-0.x86_64.rpm)
      perl -pi -e 's[CHANGE_THIS_TO_PBS_PRO_SERVER_HOSTNAME][head]' /etc/pbs.conf
    SHELL
  end

  config.vm.define "head", primary: false, autostart: true do |head|
    head.vm.network "private_network", ip: "10.0.0.101"
    head.vm.provision "shell", path: "head-setup.sh"
    head.vm.provision "shell", inline: "hostnamectl set-hostname head"
    head.vm.provision "shell", inline: "cp -f /vagrant/hosts /etc/hosts"

    install_deps!(head)
    head.vm.provision "shell", inline: <<-SHELL
      (cd /vagrant/pbspro_19.1.1.centos7 && rpm -i pbspro-server-19.1.1-0.x86_64.rpm)
      systemctl enable pbs --now
      export PATH="$PATH:/opt/pbs/bin"
      qmgr -c 'create node pbscompute'
      # qmgr -c 'create node head'  # use the head node as a compute node
      qmgr -c 'set server acl_roots+=ood'
      qmgr -c 'set server flatuid=true'
    SHELL
  end

  config.vm.define "pbscompute", primary: false, autostart: true do |pbscompute|
    pbscompute.vm.network "private_network", ip: "10.0.0.102"
    pbscompute.vm.provision "shell", inline: "hostnamectl set-hostname pbscompute"
    install_deps!(pbscompute)
    add_ood_user!(pbscompute)  # Other hosts have this as part of their setup scripts
    pbscompute.vm.provision "shell", inline: <<-SHELL
      (cd /vagrant/pbspro_19.1.1.centos7 && rpm -i pbspro-execution-19.1.1-0.x86_64.rpm)
      perl -pi -e 's[CHANGE_THIS_TO_PBS_PRO_SERVER_HOSTNAME][head]' /etc/pbs.conf
      perl -pi -e 's[CHANGE_THIS_TO_PBS_PRO_SERVER_HOSTNAME][head]' /var/spool/pbs/mom_priv/config
      yum install -y Lmod openmpi
      systemctl enable pbs --now
    SHELL
  end
end

