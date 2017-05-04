FROM centos:centos6

MAINTAINER Nikhil verma

#Install tar
RUN yum -y update; yum clean all
RUN yum -y update && \
    yum groupinstall -y development && \
    yum install -y \
    curl \
    sudo \
    tar \
    wget \
    bzip2-devel \
    hostname \
    openssl \
    openssl-devel \
    sqlite-devel \
    zlib-dev 

#Install Java8
ENV JDK_VERSION 8u11

ENV JDK_BUILD_VERSION b12

RUN curl -LO "http://download.oracle.com/otn-pub/java/jdk/$JDK_VERSION-$JDK_BUILD_VERSION/jdk-$JDK_VERSION-linux-x64.rpm" -H 'Cookie: oraclelicense=accept-securebackup-cookie' && rpm -i jdk-$JDK_VERSION-linux-x64.rpm; rm -f jdk-$JDK_VERSION-linux-x64.rpm; yum clean all

ENV JAVA_HOME /usr/java/default

# Download and Install Apache Tomcat 7
RUN cd /tmp;wget http://apache.mirrors.pair.com/tomcat/tomcat-7/v7.0.77/bin/apache-tomcat-7.0.77.tar.gz 
 
RUN cd /tmp;tar xvf apache-tomcat-7.0.77.tar.gz
 
RUN cd /tmp;mv apache-tomcat-7.0.77 /opt/tomcat7

# Install python2.7 
RUN cd /tmp && \
    wget https://www.python.org/ftp/python/2.7.8/Python-2.7.8.tgz && \
    tar xvfz Python-2.7.8.tgz && \
    cd Python-2.7.8 && \
    ./configure --prefix=/usr/local && \
    make && \
    make altinstall 

# Install setuptools and pip 
RUN cd /tmp && \
    wget --no-check-certificate https://pypi.python.org/packages/source/s/setuptools/setuptools-1.4.2.tar.gz && \
    tar -xvf setuptools-1.4.2.tar.gz && \
    cd setuptools-1.4.2 && \
    python2.7 setup.py install && \
    curl https://bootstrap.pypa.io/get-pip.py | python2.7 - && \
    pip install virtualenv

# Setup python2.7 as default
RUN echo 'alias python=/usr/local/bin/python2.7' >> ~/.bashrc

#Install MongoDB
RUN yum -y update; yum clean all
RUN yum -y install epel-release; yum clean all
RUN echo -e "[mongodb]\nname=MongoDB Repository\nbaseurl=http://downloads-distro.mongodb.org/repo/redhat/os/x86_64/\ngpgcheck=0\nenabled=1" > /etc/yum.repos.d/mongodb.repo
RUN yum -y install mongo-10gen mongo-10gen-server
RUN mkdir -p /data/db
EXPOSE 27017
 
EXPOSE 8080

CMD ["/bin/sh","/opt/tomcat7/bin/catalina.sh","run"]

