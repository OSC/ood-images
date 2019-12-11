# Setup

    cd ood-images/vagrant-with-gridengine
    vagrant plugin install vagrant-vbguest

## Vagrant

Launch and setup the VM:

    vagrant up

Note that this "cluster" is an all-in-one web node / head node / compute node.

# Usage

Access to OpenOnDemand is via the `ood` user with password `ood`.

## Vagrant

Once the VM or container is online, the Open OnDemand interface can be accessed at localhost:8080

## VMware

The VM image defaults to use DHCP.  If DHCP is not setup for the imported VM, an IP must be set.  Below is an example.

    ip addr add <IP>/<NETMASK> dev eth0
    ip route add default via <GATEWAY>

The root password for the image is `ood`.

# Development

## Vagrant

