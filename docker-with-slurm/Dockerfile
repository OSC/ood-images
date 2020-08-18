FROM centos:7 AS slurm-build
RUN mkdir /build
COPY ./slurm* /build/
COPY ./munge.key /build/
RUN /build/slurm-setup.sh && rm -rf /build

FROM slurm-build AS base
COPY ./base-setup.sh /base-setup.sh
RUN /base-setup.sh && rm -f /base-setup.sh

FROM base AS head
COPY ./*head* /build/
RUN /build/head-setup.sh && rm -rf /build
CMD ["/usr/local/sbin/launch"]

FROM base AS ood
COPY ./*ood* /build/
RUN /build/ood-setup.sh && rm -rf /build
CMD ["/usr/local/sbin/launch"]
