#!/bin/bash
#Este script levanta un contenedor conteniendo una base de datos mysql

#Create directory for the database
host_directory_db=/mysql/prestashop
mkdir -p ${host_directory_db}
#chmod
chmod 777 ${host_directory_db}


container_name=pmysql
container_net=db_network
mysql_v=5

docker stop ${container_name} || true && docker rm ${container_name} || true

#check if network exists?
#docker network create ${container_net}

docker run -ti \
	   --name ${container_name} \
           -h ${container_name}\
           -v ${host_directory_db}:/var/lib/mysql \
           -e MYSQL_DATABASE=prestashop\
 	   -e MYSQL_ROOT_PASSWORD=password\
  	   -e MYSQL_USER=ps_user\
           -e MYSQL_PASSWORD=ps_password\
	   -d mysql:${mysql_v}

#Connect container to internal network
docker network connect ${container_net} ${container_name}
