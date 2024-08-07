#!/bin/bash

chmod -R 775 /var/www/*
chown -R www-data /var/www/*
mkdir -p /run/php/
touch /run/php/php7.3-fpm.pid
if [ ! -f /var/www/wordpress/wp-config.php ]; then
# mv /var/www/wp-config.php /var/www/wordpress
wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp
cd /var/www/wordpress
wp core download --allow-root
wp config create --dbname=$MYSQL_DATABASE_NAME --dbuser=$MYSQL_USER --dbpass=$MYSQL_PASSWORD --dbhost=$WORDPRESS_DATABASE_HOST --dbcharset="utf8" --allow-root
wp core install --allow-root --url=${DOMAIN_NAME} --title=${WORDPRESS_NAME} --admin_user=${WORDPRESS_ROOT_LOGIN} --admin_password=${WORDPRESS_ROOT_PASSWD} --admin_email=${WORDPRESS_ROOT_EMAIL};
wp user create ${NO_ROOT_USER} ${NO_ROOT_USER_EMAIL} --user_pass=${NO_ROOT_USER_PASSWD} --role=author --allow-root;
fi
/usr/sbin/php-fpm7.3 -F
