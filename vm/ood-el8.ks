install
text
url --url http://mirror.centos.org/centos/8/BaseOS/x86_64/os/
repo --name=extras --baseurl=http://mirror.centos.org/centos/8/extras/x86_64/os/
repo --name=PowerTools --baseurl=http://mirror.centos.org/centos/8/PowerTools/x86_64/os/
lang en_US.UTF-8
selinux --disabled
keyboard us
skipx

network --bootproto dhcp --onboot yes --device eth0 --noipv6

# ood
rootpw --iscrypted $6$ae53b3deef007710$BOS4bylh9l4c6KWafdToj39efiVyItSTvCRk63qexkzD3J0qygzuFdCAMtFZA4A4jODC9J/7pv5riNy.a/nxA.
firewall --enable --service=ssh,http,https
authconfig --useshadow --passalgo=sha512
timezone --utc America/New_York

bootloader --location=mbr --driveorder=sda --append="nofb quiet splash=quiet net.ifnames=0 biosdevname=0" 

zerombr
clearpart --all --initlabel
autopart

%packages
yum
yum-utils
dhclient
chrony
wget
@Core
%end

%post --nochroot
exec < /dev/tty3 > /dev/tty3
#changing to VT 3 so that we can see whats going on....
/usr/bin/chvt 3
(
cp -va /etc/resolv.conf /mnt/sysimage/etc/resolv.conf
/usr/bin/chvt 1
) 2>&1 | tee /mnt/sysimage/root/install.postnochroot.log
%end
%post
logger "Starting anaconda postinstall"
exec < /dev/tty3 > /dev/tty3
#changing to VT 3 so that we can see whats going on....
/usr/bin/chvt 3
(

#update local time
echo "updating system time"
/usr/bin/chronyc makestep
/usr/sbin/hwclock --systohc

# update all the base packages from the updates repository
yum -y update

yum install -y https://yum.osc.edu/ondemand/1.8/ondemand-release-web-1.8-1.noarch.rpm
yum install -y ondemand ondemand-dex

systemctl enable httpd

sync

) 2>&1 | tee /root/install.post.log
exit 0

%end

reboot
