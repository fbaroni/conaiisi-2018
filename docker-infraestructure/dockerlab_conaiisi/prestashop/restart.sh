#!/bin/bash
#Este script levanta un contenedor con prestashop
#Es necesario que este contenedor se conecte a la misma docker network que el contenedor que contiene la base
#mysql para poder usar la resolucion de nombres de docker
inst=1
image_name=jduttweiler/prestashop:1.7
container_name=prestashop_${inst}
mysql_container_name=pmysql
container_db_net=db_network
container_balancer_net=bal_network
local_ip=10.4.9.66

docker stop ${container_name} && docker rm ${container_name}

#BUILD DOCKER IMAGE
proxy=${http_proxy}
_no_proxy=${no_proxy} #Should be localhost,127.0.0.1,::1,santafe.gob.ar,santafe.gov.ar

docker build \
        -t  ${image_name} \
        --build-arg HTTP_PROXY=${proxy} \
        --build-arg HTTPS_PROXY=${proxy} \
        --build-arg FTP_PROXY=${proxy} \
        --build-arg http_proxy=${proxy} \
        --build-arg https_proxy=${proxy} \
        --build-arg ftp_proxy=${proxy} \
        --build-arg no_proxy=${_no_proxy} .

#docker network create ${container_db_net}

#DOCKER RUN CONTAINER
docker run -ti \
	   --name ${container_name} \
	   --hostname ${container_name} \
	   --network ${container_db_net} \
	   -e DB_SERVER=${mysql_container_name} \
           -e PS_DEV_MODE=1\
           -e PS_INSTALL_AUTO=1\
           -e PS_ERASE_DB=1\
	   -e PS_DOMAIN=${local_ip}:8007\
           -e DB_USER=ps_user\
           -e DB_PASSWD=ps_password\
 	   -p 8007:80\
           -d jduttweiler/prestashop:1.7


#Connect container to external network
#docker network connect ${container_balancer_net} ${container_name}
