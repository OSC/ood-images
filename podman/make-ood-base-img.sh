#!/bin/bash -x

base_version="1.6"
ood_rpm="https://yum.osc.edu/ondemand/${base_version}/ondemand-release-web-${base_version}-1.el7.noarch.rpm"
install_cmd="yum install -y"


ctr=$(buildah from centos:7)

#install everything
buildah run $ctr -- $install_cmd centos-release-scl lsof sudo sqlite-devel
buildah run $ctr -- $install_cmd $ood_rpm
buildah run $ctr -- $install_cmd ondemand httpd24-mod_ssl httpd24-mod_ldap


#clean up and commit
buildah config --entrypoint "/opt/rh/httpd24/root/usr/sbin/httpd-scl-wrapper -DFOREGROUND" $ctr
buildah run $ctr -- yum clean all

buildah commit $ctr ood-base:latest
