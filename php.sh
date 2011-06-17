#!/bin/bash

## PHP

apt-get install php5-cgi php5-cli psmisc wget
mkdir -p /srv/www/php_bench/

echo ' <?php echo phpinfo(); ?> ' > /srv/www/php_bench/index.php

echo '
server {
       listen 81;
    server_name localhost;

    root /srv/www/php_bench/;

    location / {
        index index.html index.htm index.php;
    }

    location ~ \.php$ {
        include /etc/nginx/fastcgi_params;
        fastcgi_pass  127.0.0.1:9000;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME /srv/www/php_bench/$fastcgi_script_name;
    }
}' > /etc/nginx/sites-available/php_bench

ln -s /etc/nginx/sites-available/php_bench /etc/nginx/sites-enabled/php_bench

echo '
#!/bin/sh

FASTCGI_USER=www-data
FASTCGI_GROUP=www-data
ADDRESS=127.0.0.1
PORT=9000
PIDFILE=/var/run/php-fastcgi/php-fastcgi.pid
CHILDREN=6
PHP5=/usr/bin/php5-cgi

/usr/bin/spawn-fcgi -a $ADDRESS -p $PORT -C $CHILDREN -u $FASTCGI_USER -g $FASTCGI_GROUP -f $PHP5
' > /usr/bin/php-fastcgi

chmod +x /usr/bin/php-fastcgi

echo '
#!/bin/bash
PHP_SCRIPT=/usr/bin/php-fastcgi
FASTCGI_USER=www-data
RETVAL=0
case "$1" in
    start)
      su - $FASTCGI_USER -c $PHP_SCRIPT
      RETVAL=$?
  ;;
    stop)
      killall -9 php5-cgi
      RETVAL=$?
  ;;
    restart)
      killall -9 php5-cgi
      su - $FASTCGI_USER -c $PHP_SCRIPT
      RETVAL=$?
  ;;
    *)
      echo "Usage: php-fastcgi {start|stop|restart}"
      exit 1
  ;;
esac
exit $RETVAL
console output 
' > /etc/init.d/php-fastcgi

chmod +x /etc/init.d/php-fastcgi

/etc/init.d/php-fastcgi start
/etc/init.d/nginx start

