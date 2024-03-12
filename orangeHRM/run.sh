#!/bin/bash
currentpath=$(pwd)
docker run -d --name mariadb -e MYSQL_USER=orangeuser -e MYSQL_PASSWORD=Admin123 -e MYSQL_ROOT_PASSWORD=Admin123 -e MYSQL_DATABASE=orangedb -v /opt/docker/db:/var/lib/mysql -p 3306:3306 mariadb:10.4.12
cd $currentpath/app
docker build -t orangehrm:v1 .
docker run --name orangeapp -v /opt/docker/app:/var/www/html -p 80:80 -d orangehrm:v1	


