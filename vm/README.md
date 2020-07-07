# Virtual Machine OOD images

## VMware

Download built images at https://yum.osc.edu/ondemand/images/

The VM image defaults to use DHCP.  If DHCP is not setup for the imported VM, an IP must be set.  Below is an example.

    ip addr add <IP>/<NETMASK> dev eth0
    ip route add default via <GATEWAY>

The root password for the image is `ood`.

## Packer

Build image using packer

    packer build packer.json

### Debugging

    PACKER_LOG=1 packer build -debug -on-error=ask packer.json

Prep files and generate MD5 sums

```
VERSION=1.7.14
mv output-ood-el8/packer-ood-el8.ova output-ood-el8/ood-el8-vmware-${VERSION}.ova
mv output-ood-el7/packer-ood-el7.ova output-ood-el7/ood-el7-vmware-${VERSION}.ova
cd output-ood-el8
md5 -r ood-el8-vmware-${VERSION}.ova > ood-el8-vmware-${VERSION}.ova.md5
cd ../output-ood-el7
md5 -r ood-el7-vmware-${VERSION}.ova > ood-el7-vmware-${VERSION}.ova.md5
cd ..
scp -i ~/osc/.ssh/id_rsa \
 output-ood-el8/ood-el8-vmware-${VERSION}.ova* \
 output-ood-el7/ood-el7-vmware-${VERSION}.ova* \
 oodpkg@repo.hpc.osc.edu:/var/www/repos/public/ondemand/images/
ssh -i ~/osc/.ssh/id_rsa oodpkg@repo.hpc.osc.edu chmod 0644 /var/www/repos/public/ondemand/images/