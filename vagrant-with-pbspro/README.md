# Setup

    vagrant plugin install vagrant-vbguest  # only required once, and is not tied to a particular Vagrant file / directory
    git clone https://github.com/MorganRodgers/pbspro-workbench.git
    cd pbspro-workbench
    

## Vagrant

Launch and setup the VMs:

    vagrant up  # loads ood head pbscompute

A proper setup requires that the `ood` VM be brought up first. If `head` and `pbscompute` fail with RPM errors ensure that the [PBSPro RPM file](https://github.com/PBSPro/pbspro/releases/download/v19.1.1/pbspro_19.1.1.centos7.zip) has been downloaded and unzipped.

# Usage

Access to OpenOnDemand is via the `ood` user with password `ood`.

## Vagrant

Once the VM is loaded, the Open OnDemand interface can be accessed at localhost:8080