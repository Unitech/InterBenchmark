#!/bin/bash

# Install base

## Install fastcgi lib
apt-get install curl rubygems

## Install Rails 3.1
gem install rails --pre
gem install passenger

apt-get install build-essential bison openssl libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-0 libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf lib
apt-get install libcurl4-openssl-dev

# Install rvm and

rvm install 1.9.2



