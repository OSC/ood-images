FROM centos:7 AS slurm-build
RUN yum -y install epel-release && yum clean all && rm -rf /var/cache/yum/*
RUN yum -y install munge munge-devel libcgroup-devel curl bzip2 @buildsys-build \
  readline-devel numactl-devel pam-devel glib2-devel hwloc-devel openssl-devel curl-devel \
  && yum clean all && rm -rf /var/cache/yum/*
COPY munge.key /etc/munge/munge.key
RUN chown munge:munge /etc/munge/munge.key
RUN chmod 0600 /etc/munge/munge.key
RUN curl -o /tmp/slurm-19.05.4.tar.bz2 https://download.schedmd.com/slurm/slurm-19.05.4.tar.bz2
RUN cd /tmp && tar xf slurm-19.05.4.tar.bz2
RUN cd /tmp/slurm-19.05.4 && ./configure --prefix=/opt/slurm --sysconfdir=/opt/slurm/etc
RUN cd /tmp/slurm-19.05.4 && make -j4
RUN cd /tmp/slurm-19.05.4 && make install
RUN mkdir /opt/slurm/etc
RUN install -D -m644 /tmp/slurm-19.05.4/etc/slurmctld.service /opt/slurm/etc/
RUN install -D -m644 /tmp/slurm-19.05.4/etc/slurmd.service /opt/slurm/etc/
#  rm -rf /tmp/slurm*
COPY slurm.sh /etc/profile.d/slurm.sh
COPY slurm.conf /opt/slurm/etc/slurm.conf
RUN groupadd -r slurm
RUN useradd -r -g slurm -d /var/spool/slurm -s /sbin/nologin slurm

FROM slurm-build AS head
#COPY --from=slurm-build /opt/slurm /opt/slurm
RUN yum -y install mailx && yum clean all && rm -rf /var/cache/yum/*
RUN install -D -m644 /opt/slurm/etc/slurmctld.service /etc/systemd/system/
RUN install -D -m644 /opt/slurm/etc/slurmd.service /etc/systemd/system/
RUN install -d -o slurm -g slurm /var/spool/slurm
RUN install -d -o slurm -g slurm /var/log/slurm
RUN install -d -o slurm -g slurm /var/run/slurm
RUN install -d /var/spool/slurmd
RUN groupadd --gid 1001 ood
RUN useradd --no-create-home --gid ood --uid 1001 ood
RUN echo -n "ood" | passwd --stdin ood
RUN yum -y install openssh-server && yum clean all && rm -rf /var/cache/yum/*
RUN ssh-keygen -t rsa -b 4096 -f /etc/ssh/ssh_host_rsa_key
RUN ssh-keygen -t ecdsa -b 521 -f /etc/ssh/ssh_host_ecdsa_key
RUN ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key
RUN sed -i 's/^PasswordAuthentication.*/PasswordAuthentication yes/g' /etc/ssh/sshd_config
COPY launch-head /usr/local/sbin/launch
CMD ["/usr/local/sbin/launch"]

FROM slurm-build AS ood
#COPY --from=slurm-build /opt/slurm /opt/slurm
RUN groupadd --gid 1001 ood
RUN useradd --no-create-home --gid ood --uid 1001 ood
RUN echo -n "ood" | passwd --stdin ood
RUN yum install -y centos-release-scl https://yum.osc.edu/ondemand/latest/ondemand-release-web-latest-1-6.noarch.rpm && yum clean all && rm -rf /var/cache/yum/*
RUN yum install -y ondemand && yum clean all && rm -rf /var/cache/yum/*
RUN scl enable httpd24 -- htpasswd -b -c /opt/rh/httpd24/root/etc/httpd/.htpasswd ood ood
RUN mkdir -p /etc/ood/config/clusters.d
RUN mkdir -p /etc/ood/config/apps/shell
RUN echo "DEFAULT_SSHHOST=head" > /etc/ood/config/apps/shell/env
COPY launch-ood /usr/local/sbin/launch
CMD ["/usr/local/sbin/launch"]
