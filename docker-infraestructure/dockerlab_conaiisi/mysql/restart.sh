#!/bin/bash
#Este script levanta un contenedor conteniendo una base de datos mysql

container_name=pmysql
container_net=db_network

docker stop ${container_name} || true && docker rm ${container_name} || true

#check if network exists?
#docker network create ${container_net}

docker run -ti \
	   --name ${container_name} \
           -h ${container_name}\
           -e MYSQL_DATABASE=prestashop\
  	   -e MYSQL_USER=ps_user\
           -e MYSQL_PASSWORD=ps_password\
	   -e MYSQL_ROOT_PASSWORD=root\
	   -d mysql

#Connect container to internal network
docker network connect ${container_net} ${container_name}
