# Setup

    git clone https://github.com/treydock/ood-images.git
    cd ood-images

## Docker

Launch the container:

     docker run -p 8080:80 -d treydock/ood

## Vagrant

Launch and setup the VM:

    vagrant up

# Usage

Access to OpenOnDemand is via the `ood` user with password `ood`.

## Docker/Vagrant

Once the VM or container is online, the Open OnDemand interface can be accessed at localhost:8080

## VMware

The VM image defaults to use DHCP.  If DHCP is not setup for the imported VM, an IP must be set.  Below is an example.

    ip addr add <IP>/<NETMASK> dev eth0
    ip route add default via <GATEWAY>

The root password for the image is `ood`.

# Development

## Docker

    docker build -t treydock/ood:0.1.0 -t treydock/ood:latest .

## packer

Build image using packer

    packer build packer.json

Debugging

    PACKER_LOG=1 packer build -debug -on-error=ask packer.json

## Vagrant

