FROM centos:7 AS slurm-build
COPY . /build
RUN /build/slurm-setup.sh && rm -rf /build

FROM slurm-build AS base
COPY . /build
RUN /build/base-setup.sh && rm -rf /build

FROM base AS head
COPY . /build
RUN /build/head-setup.sh && rm -rf /build
CMD ["/usr/local/sbin/launch"]

FROM base AS ood
COPY . /build
RUN /build/ood-setup.sh && rm -rf /build
CMD ["/usr/local/sbin/launch"]
