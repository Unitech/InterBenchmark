#!/bin/bash

# Web2py with FastCgi

mkdir -p /srv/www/web2py_bench/
cd /srv/www/web2py_bench/

wget http://www.web2py.com/examples/static/web2py_src.zip
unzip web2py_src.zip

chmod -R 777 web2py
cd web2py

mv fcgihandler.py fcgihandler.fcgi

echo '
server {
listen 84;
server_name localhost;

    access_log /var/www/web2py/log/access.log;
    error_log  /var/www/web2py/log/error.log;

root /srv/www/web2py/;

location / {
          include fastcgi_params;
    fastcgi_param PATH_INFO $fastcgi_script_name;
    fastcgi_param SCRIPT_FILENAME /var/www/web2py/fcgihandler.fcgi;
    fastcgi_pass unix:/tmp/fcgi.sock;
}

}' > /etc/nginx/sites-available/web2py_bench

ln -s /etc/nginx/sites-available/web2py_bench /etc/nginx/sites-enabled/web2py_bench 
python fcgihandler.fcgi &
chmod 777 /tmp/fcgi.sock

/etc/init.d/nginx restart
