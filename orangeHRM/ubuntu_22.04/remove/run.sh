#!/bin/bash
root_pass='MariaDB123'
mariadb -uroot -p${root_pass} << EOF
DROP DATABASE focaldb;
exit
EOF
rm -rf /var/www/html/*
apt remove -y apache2* php* libapache2-mod-php php-mysql php-gd php-cli php-curl php-xml php-zip php-mbstring php-json php-intl php-ldap mariadb-server*

