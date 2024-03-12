#!/bin/bash
currentpath=$(pwd)
cd $currentpath/app
docker run -d \
  --name focaldatabase \
  -e POSTGRES_PASSWORD=Admin123 \
  -e POSTGRES_DB=focaldb \
  -e POSTGRES_USER=focaluser \
  -e POSTGRES_PASSWORD=Admin123 \
  -p 5432:5432 \
  postgres:14

IP_ADDRESSES=$(hostname -I)
LOCAL_IP=$(echo "$IP_ADDRESSES" | awk '{print $1}')
sed -i "s/\[myipaddress\]/$LOCAL_IP/g" config.json
sed -i "s/\[myipaddress\]/$LOCAL_IP/g" focalboard.conf

docker build -t focalboard:v1 .
docker run -it --name focalapp -p 80:80 -p 8000:8000 -d focalboard:v1
sleep 5
docker restart focalapp
