FROM centos:7
MAINTAINER Trey Dockendorf <tdockendorf@osc.edu>

RUN mkdir -p /opt/ood
COPY ood-setup.sh /opt/ood/ood-setup.sh

RUN yum update -y && yum clean all && rm -rf /var/cache/yum/*
RUN yum install -y \
        centos-release-scl \
        https://yum.osc.edu/ondemand/1.7/ondemand-release-web-1.7-1.noarch.rpm \
    && yum clean all && rm -rf /var/cache/yum/*
RUN yum install -y ondemand && yum clean all && rm -rf /var/cache/yum/*

RUN /opt/ood/ood-setup.sh
COPY launch-httpd /usr/local/bin/

EXPOSE 8080
EXPOSE 5556
CMD ["/usr/local/bin/launch-httpd"]
