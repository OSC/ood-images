FROM centos:7
MAINTAINER Trey Dockendorf <tdockendorf@osc.edu>

RUN mkdir -p /opt/ood
COPY ood-setup.sh /opt/ood/ood-setup.sh

RUN yum update -y && yum clean all && rm -rf /var/cache/yum/*
RUN yum install -y \
        centos-release-scl \
        https://yum.osc.edu/ondemand/1.6/ondemand-release-web-1.6-4.noarch.rpm \
    && yum clean all && rm -rf /var/cache/yum/*
RUN yum install -y ondemand && yum clean all && rm -rf /var/cache/yum/*

RUN /opt/ood/ood-setup.sh
COPY launch-httpd /usr/local/bin/

EXPOSE 80
CMD ["/usr/local/bin/launch-httpd"]
