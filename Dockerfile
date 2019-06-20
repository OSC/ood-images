FROM centos:7
MAINTAINER Trey Dockendorf <tdockendorf@osc.edu>
RUN yum install -y \
        centos-release-scl \
        https://yum.osc.edu/ondemand/1.6/ondemand-release-web-1.6-1.el7.noarch.rpm \
    && yum clean all
RUN yum install -y \
        httpd24-mod_ldap \
        httpd24-mod_ssl \
        lsof \
        ondemand \
        sqlite-devel \
        sudo \
    && yum clean all

RUN mkdir -p /opt/ood
COPY ood-setup.sh /opt/ood/ood-setup.sh
RUN /opt/ood/ood-setup.sh
COPY launch-httpd /usr/local/bin/

EXPOSE 80
CMD ["/usr/local/bin/launch-httpd"]
