#!/bin/bash

apt-get update
apt-get install build-essential unzip


# FastCGI

cd /tmp
git clone git://git.lighttpd.net/spawn-fcgi
cd spawn-fcgi
./autogen.sh && ./configure && make
sudo cp src/spawn-fcgi /usr/bin/

# PHP
./php.sh

# Webpy
./python.sh



#
# Nginx
#
# apt-get update
# apt-get install libpcre3 libpcre3-dev

# wget http://nginx.org/download/nginx-1.0.4.tar.gz
# tar zxvf nginx-1.0.4.tar.gz
# cd nginx-1.0.4

# ./configure
# make && make install

# /usr/local/nginx/sbin/nginx start

# firefox localhost

