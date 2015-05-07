#!/usr/bin/env bash

# define variables
WEB_ROOT="/var/www/html"
SERVER_NAME="local.dev"
SERVER_ALIAS="www.local.dev"
MYSQL_VERSION="5.5"
DB_NAME="dev"
########################################################
########################################################
########################################################
# update
echo "Running apt-get update"
apt-get update
# apache
echo "Installing Apache"
apt-get -y install apache2
# enable modrewrite
echo "Enabling mod-rewrite"
a2enmod rewrite
# apache config
echo "Creating Apache configuration"
echo "
<VirtualHost *:80>
        ServerAdmin webmaster@localhost
        DocumentRoot $WEB_ROOT/
		ServerName $SERVER_NAME
		ServerAlias $SERVER_ALIAS
		
		<Directory '$WEB_ROOT'>
			Options Indexes FollowSymLinks MultiViews
			AllowOverride All
			Order allow,deny
			allow from all
		</Directory>

        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
" > /etc/apache2/sites-available/dev.conf
# define localhost
echo "ServerName localhost" >> /etc/apache2/apache2.conf 
# activate site
echo "Activating new site"
a2ensite dev.conf
# set locale
echo "Setting locales"
locale-gen en_US en_US.UTF-8 pl_PL pl_PL.UTF-8
dpkg-reconfigure locales
# install MySQL
echo "Installing MySQL $MYSQL_VERSION"
export DEBIAN_FRONTEND=noninteractive
apt-get -q -y install mysql-server-$MYSQL_VERSION mysql-client-$MYSQL_VERSION
# create dev database
echo "Creating $DB_NAME database"
mysql -u root -e "create database $DB_NAME;"
# install php 5.5
echo "Installing php5"
apt-get -y install php5
# set up php
echo "Setting up php"
apt-get -y install php5-mhash php5-mcrypt php5-curl php5-cli php5-mysql php5-gd php5-intl php5-common php-pear php5-dev
# mcrypt fix
echo "Patching mcrypt"
php5enmod mcrypt
echo "Restarting Apache"
service apache2 restart
# set timezone
echo "Setting timezone in php.ini"
echo "date.timezone = America/New_York" >> /etc/php5/cli/php.ini
echo "date.timezone = America/New_York" >> /etc/php5/apache2/php.ini
# setting pecl php_ini location
echo "Setting up Pecl"
pear config-set php_ini /etc/php5/apache2/php.ini
# xdebug
echo "Installing XDebug"
pecl install xdebug
# Install Pecl Config variables
echo "Configuring XDebug"
echo "xdebug.remote_enable = 1" >> /etc/php5/apache2/php.ini
echo "xdebug.remote_connect_back = 1" >> /etc/php5/apache2/php.ini
# git
echo "Installing git"
apt-get -y install git
# memcached
echo "Installing memcached"
apt-get -y install memcached
# redis
echo "Installing redis"
apt-get -y install redis-server
# composer
echo "Installling Composer"
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer
# permissions
echo "Fixing permissions"
chown -R www-data $WEB_ROOT
find $WEB_ROOT -type d -exec chmod 700 {} \;
find $WEB_ROOT -type f -exec chmod 600 {} \;
# Post Up Message
echo
echo
echo "Vagrant ready!"
echo
if [ -z "$1" ]
	then
		echo "Server IP: 192.168.40.74"
		echo "SSH: vagrant ssh"
		echo "Root Username: vagrant"
		echo "Root Password: vagrant"
		echo "Database Username: root"
    		echo "Database Password: (none)"
    		echo "Database Name: $DB_NAME"
    		echo "URL: http://192.168.40.74/"
    		echo "Host file configuration: 192.168.40.74 $SERVER_ALIAS $SERVER_NAME"
		echo "Share externally: vagrant share"		
		echo "Memcached: localhost 11211"
		echo "Redis: localhost 6379"
fi

