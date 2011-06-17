#!/bin/bash

echo 'Django for NGINX'
set -e

wget http://www.djangoproject.com/download/1.3/tarball/ #-o 'Django-1.3.tar.gz'
mv index.html Django-1.3.tar.gz

tar xzvf Django-1.3.tar.gz
cd Django-1.3
python setup.py install


echo '
server {
listen 83;
server_name localhost;

root /srv/www/django_bench/;

location / {
                        # host and port to fastcgi server
                        fastcgi_pass 127.0.0.1:8801;
                        fastcgi_param PATH_INFO $fastcgi_script_name;
                        fastcgi_param REQUEST_METHOD $request_method;
                        fastcgi_param QUERY_STRING $query_string;
                        fastcgi_param SERVER_NAME $server_name;
                        fastcgi_param SERVER_PORT $server_port;
                        fastcgi_param SERVER_PROTOCOL $server_protocol;
                        fastcgi_param CONTENT_TYPE $content_type;
                        fastcgi_param CONTENT_LENGTH $content_length;
                        fastcgi_pass_header Authorization;
                        fastcgi_intercept_errors off;
}
}
' > /etc/nginx/sites-available/django_bench

ln -s /etc/nginx/sites-available/django_bench /etc/nginx/sites-enabled

tar zxvf django_bench_project.tar.gz

mkdir /srv/www/django_bench

cp -r django_bench_project /srv/www/django_bench/bench

python manage.py runfcgi method=threaded host=127.0.0.1 port=8801
