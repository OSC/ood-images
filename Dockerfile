FROM centos:6
MAINTAINER Trey Dockendorf <tdockendorf@osc.edu>
RUN yum install -y centos-release-scl lsof sudo sqlite-devel
RUN yum install -y \
  httpd24 \
  nginx16 \
  rh-passenger40 \
  rh-ruby22 \
  rh-ruby22-rubygem-rake \
  rh-ruby22-rubygem-bundler \
  rh-ruby22-ruby-devel \
  nodejs010 \
  git19
RUN mkdir -p /opt/ood
COPY ood-setup.sh /opt/ood/ood-setup.sh
RUN /opt/ood/ood-setup.sh

COPY launch-httpd /usr/local/bin/
RUN mkdir -p /etc/ood/config/clusters.d

RUN yum install -y \
  httpd24-mod_ssl \
  httpd24-mod_ldap

EXPOSE 80
CMD ["/usr/local/bin/launch-httpd"]
