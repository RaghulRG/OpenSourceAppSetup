#!/bin/bash
root_pass='MariaDB123'
user_pass='OSuser123'
apt install apache2 mariadb-server php libapache2-mod-php php-mysql php-cgi php-fpm php-cli php-curl php-gd php-imap php-mbstring php-pear php-intl php-apcu php-common php-bcmath -y
systemctl start apache2
systemctl enable apache2
systemctl start mariadb
systemctl enable mariadb
mariadb -uroot -p"$root_pass" << EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY $root_pass;
CREATE USER 'root'@'%' IDENTIFIED BY $root_pass;
CREATE USER 'ostuser'@'%' IDENTIFIED BY $user_pass;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO 'ostuser'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
exit
EOF
mariadb -uroot -p"$root_pass" << EOF
CREATE DATABASE OSdb;
EOF
version=$(curl -s https://raw.githubusercontent.com/osTicket/osTicket/develop/WHATSNEW.md | head -1 | awk {'print$2'})
cd /var/www/html
wget https://github.com/osTicket/osTicket/releases/download/${version}/osTicket-${version}.zip
unzip osTicket-${version}.zip
mv upload osticket
chown -R www-data:www-data /var/www/html/osticket
chmod -R 775 /var/www/html/osticket
mv /var/www/html/osticket/include/ost-sampleconfig.php /var/www/html/osticket/include/ost-config.php
rm -rf /var/www/html/osTicket-*.zip scripts
cat > /etc/apache2/sites-available/osticket.conf << EOF
<VirtualHost *:80>
        ServerName osticket.example.com
        ServerAdmin admin@localhost
        DocumentRoot /var/www/html/osticket

        <Directory /var/www/html/osticket>
                Require all granted
                Options FollowSymlinks
                AllowOverride All
        </Directory>

        ErrorLog ${APACHE_LOG_DIR}/osticket.error.log
        CustomLog ${APACHE_LOG_DIR}/osticket.access.log combined
</VirtualHost>
EOF
a2ensite osticket.conf
a2enmod rewrite
systemctl restart apache2
old_line=$(grep -ir 'bind-address' /etc/mysql/* | grep '127.0.0.1' | awk -F':' '{print $2}')
file_path=$(grep -ir 'bind-address' /etc/mysql/* | grep '127.0.0.1' | awk -F':' '{print $1}')
if [ "$old_line" != "" -o "$file_path" != "" ]; then
	sed -i "s/$old_line/bind-address = 0.0.0.0/g" "$file_path"
fi

