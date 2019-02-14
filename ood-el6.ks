install
text
url --url http://mirror.centos.org/centos/6/os/x86_64/
repo --name=extras --baseurl=http://mirror.centos.org/centos/6/extras/x86_64/
lang en_US.UTF-8
selinux --disabled
keyboard us
skipx

network --bootproto dhcp --onboot yes --device eth0 --noipv6

# ood
rootpw --iscrypted $6$ae53b3deef007710$BOS4bylh9l4c6KWafdToj39efiVyItSTvCRk63qexkzD3J0qygzuFdCAMtFZA4A4jODC9J/7pv5riNy.a/nxA.
firewall --ssh --http --port=https:tcp
authconfig --useshadow --passalgo=sha512
timezone --utc America/New_York

bootloader --location=mbr --driveorder=sda --append="nofb quiet splash=quiet" 

zerombr
clearpart --all --initlabel
autopart

%packages
yum
dhclient
ntp
wget
@Core
lsof
sudo
sqlite-devel
epel-release
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
/usr/sbin/ntpdate -sub 0.fedora.pool.ntp.org
/usr/sbin/hwclock --systohc

# update all the base packages from the updates repository
yum -t -y update

yum install -y centos-release-scl
yum install -y https://yum.osc.edu/ondemand/1.5/ondemand-release-web-1.5-1.el7.noarch.rpm
yum install -y ondemand

chkconfig httpd24-httpd on

sync

) 2>&1 | tee /root/install.post.log
exit 0

%end

reboot
