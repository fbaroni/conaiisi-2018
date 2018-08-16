#!/bin/bash
#Este script levanta un contenedor con prestashop
#Es necesario que este contenedor se conecte a la misma docker network que el contenedor que contiene la base
#mysql para poder usar la resolucion de nombres de docker
inst=2
image_name=jduttweiler/prestashop:1.7
container_name=prestashop_${inst}
mysql_container_name=pmysql
container_db_net=db_network
container_balancer_net=bal_network
host_name=localhost
host_external_port=8008
container_external_port=80

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
           -e DB_USER=ps_user\
           -e DB_NAME=prestashop\
           -e DB_PASSWD=ps_password\
           -e HTTP_PROXY=${proxy} \
           -e HTTPS_PROXY=${proxy} \
           -e FTP_PROXY=${proxy} \
           -e http_proxy=${proxy} \
           -e https_proxy=${proxy} \
           -e ftp_proxy=${proxy} \
 	   -p ${host_external_port}:${container_external_port}\
           -d jduttweiler/prestashop:1.7

#          -e PS_DEV_MODE=1\
#          -e PS_INSTALL_AUTO=1\
#          -e PS_ERASE_DB=1\
#           -e PS_DOMAIN=${container_name}:${container_external_port}\



#Connect container to external network
#docker network connect ${container_balancer_net} ${container_name}
