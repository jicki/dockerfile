FROM centos

MAINTAINER ict@moxiangroup.com 
USER root
 
# 添加erepo 源
RUN yum -y update;yum clean all
RUN yum -y install epel-release
RUN yum -y install --enablerepo base wget tar.x86_64 && mkdir -p /opt/local && wget -q -O - https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-v2.6-latest.tgz | tar -xzf - -C /opt/local/ && mv /opt/local/mongodb-linux* /opt/local/mongodb

ADD mongod.conf /opt/local/mongodb/

WORKDIR /opt/local/mongodb

#修改配置文件
RUN localedef -i zh_CN -c -f UTF-8 zh_CN.UTF-8
RUN rm -rf /etc/localtime
RUN ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
ENTRYPOINT ["/opt/local/mongodb/bin/mongod", "-f", "/opt/local/mongodb/mongod.conf"]
