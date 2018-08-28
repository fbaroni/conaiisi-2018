#!/bin/bash
#Este script levanta un contenedor conteniendo una base de datos mysql

container_name=pmysql
container_net=db_network
mysql_v=5

docker stop ${container_name} && docker rm ${container_name} 

#check if network exists?
#docker network create ${container_net}
docker run -ti \
		--name ${container_name} \
		--mount source=mysql-volume,target=/var/lib/mysql \
		--hostname ${container_name}\
		-e MYSQL_DATABASE=prestashop\
		-e MYSQL_ROOT_PASSWORD=password\
		-e MYSQL_USER=ps_user\
		-e MYSQL_PASSWORD=ps_password\
		-d mysql:${mysql_v}

#Connect container to internal network
docker network connect ${container_net} ${container_name}
