FROM centos:7
MAINTAINER Trey Dockendorf <tdockendorf@osc.edu>
RUN yum install -y centos-release-scl lsof sudo sqlite-devel
RUN yum install -y https://yum.osc.edu/ondemand/1.5/ondemand-release-web-1.5-1.el7.noarch.rpm
RUN yum install -y ondemand
RUN mkdir -p /opt/ood
COPY ood-setup.sh /opt/ood/ood-setup.sh
RUN /opt/ood/ood-setup.sh

COPY launch-httpd /usr/local/bin/

RUN yum install -y \
  httpd24-mod_ssl \
  httpd24-mod_ldap

EXPOSE 80
CMD ["/usr/local/bin/launch-httpd"]
