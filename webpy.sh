#!/bin/bash

#
# Web.py 
# http://webpy.org/
#

apt-get install python-setuptools python-flup

easy_install web.py

mkdir -p /srv/www/webpy_bench

echo '#!/usr/bin/env python
# -*- coding: utf-8 -*-

import web

urls = ("/.*", "hello")
app = web.application(urls, globals())

class hello:
    def GET(self):
        return "Hello, world!"

if __name__ == "__main__":
    web.wsgi.runwsgi = lambda func, addr=None: web.wsgi.runfcgi(func, addr)
    app.run()
' > /srv/www/webpy_bench/index.py

chmod +x /srv/www/webpy_bench/index.py

echo 'server {
    listen 82;
    server_name localhost;

    root /srv/www/webpy_bench/;

    location / {
        fastcgi_param REQUEST_METHOD $request_method;
        fastcgi_param QUERY_STRING $query_string;
        fastcgi_param CONTENT_TYPE $content_type;
        fastcgi_param CONTENT_LENGTH $content_length;
        fastcgi_param GATEWAY_INTERFACE CGI/1.1;
        fastcgi_param SERVER_SOFTWARE nginx/$nginx_version;
        fastcgi_param REMOTE_ADDR $remote_addr;
        fastcgi_param REMOTE_PORT $remote_port;
        fastcgi_param SERVER_ADDR $server_addr;
        fastcgi_param SERVER_PORT $server_port;
        fastcgi_param SERVER_NAME $server_name;
        fastcgi_param SERVER_PROTOCOL $server_protocol;
        fastcgi_param SCRIPT_FILENAME $fastcgi_script_name;
        fastcgi_param PATH_INFO $fastcgi_script_name;
        fastcgi_pass 127.0.0.1:9002;
     }
} ' > /etc/nginx/sites-available/webpy_bench

ln -s /etc/nginx/sites-available/webpy_bench /etc/nginx/sites-enabled/webpy_bench

spawn-fcgi -d /srv/www/webpy_bench -f /srv/www/webpy_bench/index.py -a 127.0.0.1 -p 9002
