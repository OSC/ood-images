# Setup

    git clone https://github.com/OSC/ood-images.git
    cd ood-images

## Docker

Launch the container:

    docker run -p 8080:80 -d --name ood ohiosupercomputer/ood

To set default SSH host for shell app:

    docker run -p 8080:80 -d --name ood -e DEFAULT_SSHHOST=login.my_center.edu ohiosupercomputer/ood

Add a cluster configuration file

    docker cp <cluster name>.yaml ood:/etc/ood/config/clusters.d/<cluster name>.yaml

## Vagrant

Launch and setup the VM:

    vagrant up

## VMware

Download built images at https://yum.osc.edu/ondemand/images/

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

    docker build -t ohiosupercomputer/ood:1.5.0 -t ohiosupercomputer/ood:latest .

## packer

Build image using packer

    packer build packer.json

Debugging

    PACKER_LOG=1 packer build -debug -on-error=ask packer.json

Prep files and generate MD5 sums

```
VERSION=1.6.0
mv output-ood-el6/packer-ood-el6.ova output-ood-el6/ood-el6-vmware-${VERSION}.ova
mv output-ood-el7/packer-ood-el7.ova output-ood-el7/ood-el7-vmware-${VERSION}.ova
cd output-ood-el6
md5 -r ood-el6-vmware-${VERSION}.ova > ood-el6-vmware-${VERSION}.ova.md5
cd ../output-ood-el7
md5 -r ood-el7-vmware-${VERSION}.ova > ood-el7-vmware-${VERSION}.ova.md5
scp -i ~/osc/.ssh/id_rsa\
 output-ood-el6/ood-el6-vmware-${VERSION}.ova* \
 output-ood-el7/ood-el7-vmware-${VERSION}.ova* \
 oodpkg@repo.hpc.osc.edu:/var/www/repos/public/ondemand/images/
```

## Vagrant

