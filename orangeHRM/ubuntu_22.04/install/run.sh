#!/bin/bash
root_pass='MariaDB123'
user_pass='Focaluser123'
apt update -y
apt install mariadb-server -y
mariadb -uroot -p"$root_pass" << EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY $root_pass;
CREATE USER 'root'@'%' IDENTIFIED BY $root_pass;
CREATE USER 'focaluser'@'%' IDENTIFIED BY $user_pass;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO 'focaluser'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
exit
EOF
mariadb -uroot -p"$root_pass" << EOF
CREATE DATABASE focaldb;
EOF
apt-get install -y curl wget apache2 php libapache2-mod-php php-mysql php-gd php-cli php-curl php-xml php-zip php-mbstring php-json php-intl php-ldap unzip
version=$(curl -s https://raw.githubusercontent.com/orangehrm/orangehrm/main/build/build.xml | grep -oP 'name="version" value="\K[^"]+')
cd /var/www/html
wget https://excellmedia.dl.sourceforge.net/project/orangehrm/stable/${version}/orangehrm-${version}.zip
unzip orangehrm-${version}.zip
mv orangehrm-${version} orangehrm
chmod -R 775 orangehrm
rm -rf /var/www/html/logo.png /var/www/html/orangehrm-*.zip /var/www/html/orangehrm-quick-start-guide.html
chown -R www-data:www-data /var/www/html/orangehrm
old_line=$(grep -ir 'bind-address' /etc/mysql/* | grep '127.0.0.1' | awk -F':' '{print $2}')
file_path=$(grep -ir 'bind-address' /etc/mysql/* | grep '127.0.0.1' | awk -F':' '{print $1}')
sed -i "s/$old_line/bind-address = 0.0.0.0/g" "$file_path"
