# PBS Professional

## Setup

Launch and setup the VMs:

    vagrant up  # loads ood head pbscompute

A proper setup requires that the `ood` VM be brought up first to download the PBSPro RPM. If `head` and `pbscompute` fail with RPM errors ensure that the [PBSPro RPM file](https://github.com/PBSPro/pbspro/releases/download/v19.1.1/pbspro_19.1.1.centos7.zip) has download and unzip succeeded.

## Usage

Access to OpenOnDemand is via the `ood` user with password `ood`. Once the VM is loaded, the Open OnDemand interface can be accessed at `http://localhost:8080`
