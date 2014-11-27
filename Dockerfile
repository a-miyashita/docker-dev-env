FROM phusion/baseimage

MAINTAINER Akihiro MIYASHITA <akihiro.miyashita@gmail.com>

# apt settings
RUN sed -i~ -e 's/archive.ubuntu.com/ftp.jaist.ac.jp/' /etc/apt/sources.list
RUN apt-get update && apt-get upgrade -y
ENV DEBIAN_FRONTEND noninteractive

### development environment ###
# add-apt-repository
RUN apt-get install -y --no-install-recommends software-properties-common

# version control systems
RUN apt-get install -y --no-install-recommends git gitk mercurial subversion

# python
RUN apt-get install -y --no-install-recommends python

# oracle jdks (6, 7, 8)
RUN add-apt-repository ppa:webupd8team/java -y && apt-get update
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true|/usr/bin/debconf-set-selections
RUN apt-get install -y --no-install-recommends oracle-java8-installer

# xserver
RUN apt-get install -y --no-install-recommends xserver-xorg xinit xterm xdm xrdp tightvncserver
RUN apt-get install -y --no-install-recommends xvfb lxde xfonts-base
RUN sed -e '/\[xrdp2\]/,$d' -e 's/=ask/=developer/g' -i /etc/xrdp/xrdp.ini

# add a developer
RUN apt-get install -y --no-install-recommends sudo
RUN adduser --disabled-password --gecos "Developer" developer
RUN adduser developer sudo
RUN adduser developer users
RUN echo "developer:developer" | chpasswd
RUN echo lxsession -s LXDE -e LXDE > /home/developer/.xsession
RUN chown developer:developer /home/developer/.xsession

EXPOSE 3389

