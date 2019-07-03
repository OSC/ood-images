#!/bin/bash -x


ctr=$(buildah from ood-base:latest)
env_dir="/etc/ood/config/apps/dashboard/"
launch_dir="/usr/local/bin"

launch_file="launch-httpd"
launch_file_full="$launch_dir/$launch_file"


# add yourself as a user and become a no password sudoer
buildah run $ctr -- groupadd $USER
buildah run $ctr -- useradd -u $(id -u) --create-home --gid $USER $USER
buildah run $ctr -- scl enable httpd24 -- htpasswd -b -c /opt/rh/httpd24/root/etc/httpd/.htpasswd $USER $USER
buildah run $ctr -- usermod -a -G wheel $USER
buildah run $ctr -- passwd --delete $USER
buildah run $ctr -- passwd --delete root


# cp the entry point and env file
buildah run $ctr -- mkdir -p $env_dir
buildah copy $ctr env $env_dir
buildah copy $ctr $launch_file $launch_dir
buildah config --entrypoint $launch_file_full $ctr

# commit img and clean up
buildah commit $ctr ood-$USER:latest
buildah rm $ctr
