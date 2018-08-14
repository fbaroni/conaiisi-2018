#!/bin/bash
echo "RESTARTING DOCKER CONTAINER MYSQL"

image_name=mysql
container_name=mysql-conaiisi
password=root

docker stop ${container_name} || true
docker rm ${container_name} || true

docker run -d -p 3037:3036 -v ${PWD}/mysql:/var/lib/mysql \
           --hostname=${container_name} \
           --name=${container_name} \
           -e MYSQL_ROOT_PASSWORD=${password}  \
           -d mysql:latest

#docker network connect lamp_network ${container_name}
sudo chmod 777 -R mysql/
docker exec -it ${container_name} /bin/bash