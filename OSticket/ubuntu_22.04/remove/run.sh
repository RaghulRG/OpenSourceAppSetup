#!/bin/bash
root_pass='MariaDB123'
mariadb -uroot -p${root_pass} << EOF
DROP DATABASE OSdb;
exit
EOF
rm -rf /var/www/html/*
apt remove -y apache2* php* mariadb*
rm -rf /etc/apache2/sites-available/osticket.conf

