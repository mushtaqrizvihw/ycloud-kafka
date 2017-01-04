FROM centos:7

RUN yum install wget -y \
    && yum install iproute -y \
    && yum install -y which \
    && yum install -y java-1.8.0-openjdk-devel \
    && yum install -y telnet bind-tools net-tools; yum clean all

ENV JAVA_HOME /usr/lib/jvm/jre-1.8.0-openjdk

# Install HDP 2.3.0.0 repo. TODO: Parametrize version
RUN wget -nv http://public-repo-1.hortonworks.com/HDP/centos7/2.x/updates/2.5.0.0/hdp.repo \
    && mv hdp.repo /etc/yum.repos.d/ \
    && yum updateinfo; yum clean all

RUN yum install -y kafka; yum clean all

# 9092 is kafka
EXPOSE 9092

## Gross hack to enable Slider agent running as nobody to go and replace files under the following directories.
RUN mkdir -p /etc/kafka/conf && chmod -R a+w /etc/kafka/conf
RUN mkdir -p /var/run/kafka && chmod -R a+w /var/run/kafka
RUN mkdir -p /var/log/kafka && chmod -R a+w /var/log/kafka
