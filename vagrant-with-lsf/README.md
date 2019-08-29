## How To Download LSF Community

LSF Community edition version is available for free to IBM community members and may be downloaded by the following steps:

- Create a free [IBM community account](https://community.ibm.com/community/user/gettingstarted/home)
- Click [here](https://www-01.ibm.com/marketing/iwm/iwm/web/preLogin.do?source=swerpzsw-lsf-3)
- Agree to the license
- Click the tab for download using HTTP
- Click download now for "IBM Spectrum LSF Suite for Community 10.x Installation Package for Linux x86-64"
- Copy the file `lsfsce10.2.0.6-x86_64.tar.gz` to the root of the `lsf-workbench` repo.

## The LSF Installation

This Vagrant setup installs the version of LSF Community edition that the user provides, but expects version 10.2.0.6. LSF clients are installed to `head` and `ood`. `head` is both the batch and the only compute node.

The LSF quick start: https://www.ibm.com/support/knowledgecenter/en/SSWRJV_10.1.0/lsf_offering/lsfce10.1_quick_start.html

## Setup

    vagrant plugin install vagrant-vbguest  # only required once, and is not tied to a particular Vagrant file / directory
    git clone https://github.com/MorganRodgers/lsf-workbench.git
    cd lsf-workbench
    

## Vagrant

Launch and setup the VMs:

    vagrant up  # loads head ood

A proper setup requires that the `head` VM be brought up first.

# Usage

Access to OpenOnDemand is via the `ood` user with password `ood`.

## Vagrant

Once the VM is loaded, the Open OnDemand interface can be accessed at localhost:8080