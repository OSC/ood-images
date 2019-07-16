#!/bin/bash

ctr=$(buildah from centos:7) 

dev_packages="lsof sudo sqlite-devel gcc rh-ruby24-ruby-devel zlib-devel git curl make wget"
dev_packages="${dev_packages} rh-nodejs6 rh-ruby24 rpm-build"

buildah run $ctr -- yum install -y centos-release-scl
buildah run $ctr -- yum-config-manager --enable rhel-server-rhscl-7-rpms

buildah run $ctr -- yum install -y ${dev_packages}
buildah run $ctr -- yum clean all

buildah run $ctr -- groupadd $USER
buildah run $ctr -- useradd -u $(id -u) --create-home --gid $USER $USER
buildah run $ctr -- usermod -a -G wheel $USER
buildah run $ctr -- passwd --delete $USER
buildah run $ctr -- passwd --delete root

buildah copy $ctr bashrc $HOME/.bashrc

buildah commit $ctr ood-dev:latest
buildah rm $ctr
