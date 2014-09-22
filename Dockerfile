# Dockerfile for an image with CoAP tools

FROM ubuntu:14.04

MAINTAINER Markus Becker <markushx@gmail.com>

ENV LC_ALL C
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

ENV HOME /root

RUN apt-get update && apt-get install -y --no-install-recommends git autoconf automake gcc make libtool gettext libcunit1 libcunit1-dev clang default-jdk ant maven nodejs npm python firefox ruby cmake

RUN mkdir /root/src
WORKDIR /root/src

################
# C

# libcoap
WORKDIR /root/src
RUN git clone git://git.code.sf.net/p/libcoap/code libcoap
WORKDIR /root/src/libcoap
RUN autoconf
RUN ./configure
RUN make

# smcp
WORKDIR /root/src
RUN git clone https://github.com/darconeous/smcp.git
WORKDIR /root/src/smcp
RUN ./bootstrap.sh
RUN ./configure
RUN make

# microcoap
WORKDIR /root/src
RUN git clone https://github.com/1248/microcoap.git
WORKDIR /root/src/microcoap
RUN make

# cantcoap
WORKDIR /root/src
RUN git clone https://github.com/staropram/cantcoap.git
WORKDIR /root/src/cantcoap
RUN make

################
# JAVA

# californium
WORKDIR /root/src
RUN git clone https://github.com/mkovatsc/Californium.git
WORKDIR /root/src/Californium
RUN mvn clean install

# ncoap
# TODO
# WORKDIR /root/src
# RUN git clone https://github.com/okleine/nCoAP.git
# WORKDIR /root/src/nCoAP
# RUN mvn -X compile ncoap-complete
# RUN mvn compile ncoap-core
# RUN mvn compile ncoap-simple-client
# RUN mvn compile ncoap-simple-server

# mr coap
# TODO

################
# C#

# CoAP.NET
# TODO
# https://github.com/smeshlink/CoAP.NET.git

# CoAPsharp
# TODO

################
# Javascript

# nodecoap
WORKDIR /root/src
RUN npm install coap

# coap-cli
WORKDIR /root/src
RUN npm install coap-cli -g

################
# Python

# txThings
# TODO: Check installation of python-setuptools
RUN apt-get update && apt-get install -y --no-install-recommends python-twisted-core python-twisted-web python-openssl python-setuptools python-dev
WORKDIR /root/src
RUN git clone https://github.com/siskin/txThings.git
WORKDIR /root/src/txThings
# TODO: Seems not to work. Fix it
RUN python setup.py install

# coapy
WORKDIR /root/src
RUN git clone git://git.code.sf.net/p/coapy/code coapy
WORKDIR /root/src/coapy
RUN python setup.py install

# CoAP
WORKDIR /root/src
RUN git clone https://github.com/okoye/COAP.git

################
# Ruby
WORKDIR /root/src
RUN gem install coap

################
# LWM2M

# wakaama
WORKDIR /root/src
RUN git clone https://github.com/01org/liblwm2m.git
WORKDIR /root/src/liblwm2m

RUN mkdir /root/src/liblwm2m/build/
WORKDIR /root/src/liblwm2m/buildserver/
RUN cmake /root/src/liblwm2m/tests/server
RUN make

WORKDIR /root/src/liblwm2m/buildclient/
RUN cmake /root/src/liblwm2m/tests/client
RUN make

# leshan
WORKDIR /root/src
RUN git clone https://github.com/jvermillard/leshan.git
WORKDIR /root/src/leshan
RUN mvn install
WORKDIR /root/src/leshan/leshan-standalone
RUN mvn assembly:assembly -DdescriptorId=jar-with-dependencies

################

RUN apt-get install -y wget

# firefox with copper
WORKDIR /root/src
RUN mkdir copper
RUN wget https://addons.mozilla.org/firefox/downloads/file/248894/copper_cu-0.18.4-fx.xpi

RUN mkdir /usr/lib/firefox-addons/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}
RUN cp copper_cu-0.18.4-fx.xpi /usr/lib/firefox-addons/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}
RUN rm copper_cu-0.18.4-fx.xpi
WORKDIR /root/src
RUN rmdir copper

RUN apt-get install -y --no-install-recommends x11vnc xvfb lxde gtk2-engines-murrine ttf-ubuntu-font-family

################

# contiki
# tinyos

################

# Bug in docker:
RUN echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf
RUN echo "net.ipv6.conf.default.disable_ipv6 = 1" >> /etc/sysctl.conf
RUN echo "net.ipv6.conf.lo.disable_ipv6 = 1" >> /etc/sysctl.conf

WORKDIR /root/src

# CoAP
EXPOSE 5683

# VNC
EXPOSE 5999

ADD startup.sh /root/
ENTRYPOINT ["/root/startup.sh"]
