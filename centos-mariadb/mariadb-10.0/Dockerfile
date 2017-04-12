FROM centos:latest
MAINTAINER dayreiner

ENV MARIADB_MAJOR=10.0

# MariaDB Repo
COPY config/MariaDB.repo /etc/yum.repos.d/MariaDB.repo

# Install required packages and MariaDB Vendor Repo
RUN yum -y update && yum clean all && yum -y install epel-release && \
    sed -i 's#yum\.mariadb\.org#mirrors.ustc.edu.cn/mariadb/yum#' /etc/yum.repos.d/MariaDB.repo && \
    rpm --import https://yum.mariadb.org/RPM-GPG-KEY-MariaDB && \
    groupadd -g 250 -r mysql && useradd -u 250 -r -g mysql mysql && \
    yum -y install https://www.percona.com/redir/downloads/percona-release/redhat/latest/percona-release-0.1-4.noarch.rpm && \
    yum -y install MariaDB-server MariaDB-client galera percona-xtrabackup-24 less which socat pwgen && yum clean all && \
    mkdir /docker-entrypoint-initdb.d

RUN rm -rf /var/lib/mysql && mkdir /var/lib/mysql

COPY config/server.cnf /etc/my.cnf.d/server.cnf
COPY scripts/docker-entrypoint.sh /docker-entrypoint.sh

EXPOSE 3306
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["mysqld"]
