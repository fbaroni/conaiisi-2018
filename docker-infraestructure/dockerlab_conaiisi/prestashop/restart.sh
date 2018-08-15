#!/bin/bash
#Este script levanta un contenedor con prestashop
#Es necesario que este contenedor se conecte a la misma docker network que el contenedor que contiene la base
#mysql para poder usar la resolucion de nombres de docker
inst=1
container_name=prestashop_${inst}
mysql_container_name=pmysql
container_db_net=db_network
container_balancer_net=bal_network

docker stop ${container_name} || true && docker rm ${container_name} || true

#check if network exists?
#docker network create ${container_db_net}

docker run -ti \
	   --name ${container_name} \
	   --hostname ${container_name} \
	   --network ${container_db_net} \
	   -e DB_SERVER=${mysql_container_name} \
           -e DB_USER=ps_user\
           -e DB_PASSWD=ps_password\
 	   --publish-all\
           -d prestashop/prestashop

#           -e PS_DEV_MODE=1\
#           -e PS_INSTALL_AUTO=1\
#           -e PS_ERASE_DB=1\



#Connect container to external network
#docker network connect ${container_balancer_net} ${container_name}
