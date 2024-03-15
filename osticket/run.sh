#!/bin/bash
currentpath=$(pwd)
root_pass='MariaDB123'
user_pass='OSuser123'
docker run -d --name osdb \
    -e MYSQL_USER=osuser \
    -e MYSQL_PASSWORD=${user_pass} \
    -e MYSQL_ROOT_PASSWORD=${root_pass} \
    -e MYSQL_DATABASE=osdb \
    -v /opt/docker/db:/var/lib/mysql \
    -p 3306:3306 mariadb:10.6
docker exec osdb mariadb -uroot -p"$root_pass" << EOF
    ALTER USER 'root'@'localhost' IDENTIFIED BY '$root_pass';
    CREATE USER 'root'@'%' IDENTIFIED BY '$root_pass';
    CREATE USER 'ostuser'@'%' IDENTIFIED BY '$user_pass';
    GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
    GRANT ALL PRIVILEGES ON *.* TO 'ostuser'@'%' WITH GRANT OPTION;
    FLUSH PRIVILEGES;
    exit
EOF
docker exec osdb mariadb -uroot -p"$root_pass" << EOF
    CREATE DATABASE OSdb;
EOF
cd $currentpath/app
docker build -t osticket:v1 .
docker run --name osticketapp -v /opt/docker/app:/var/www/html -p 80:80 -d osticket:v1	


