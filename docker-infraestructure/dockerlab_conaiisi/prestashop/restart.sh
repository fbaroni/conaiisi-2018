#!/bin/bash
#Este script levanta un contenedor con prestashop
#Es necesario que este contenedor se conecte a la misma docker network que el contenedor que contiene la base
#mysql para poder usar la resolucion de nombres de docker

####################################################################################
###                        OPTIONS & ARGUMENTS                                   ###
####################################################################################
DRY_RUN=false
FULL_RESTART=false
INSTANCE_NUMBER=1
host_external_port=8008

while true; do
  case "$1" in
    -d | --dry-run ) DRY_RUN=true; shift 1;;
	-f | --full-restart ) FULL_RESTART=true; shift 1;;
    -i | --instance ) INSTANCE_NUMBER=$2; shift 2;;
    -p | --external-port ) host_external_port=$2; shift 2;;
    * ) break ;;
  esac
done


#----------------------------------------------------------------------------------#
#                                 GLOBAL OPTIONS                                   #
#----------------------------------------------------------------------------------#
image_name=jduttweiler/prestashop:1.7
container_name=prestashop_${INSTANCE_NUMBER}
mysql_container_name=pmysql
container_db_net=db_network
container_balancer_net=bal_network
host_name=localhost
container_external_port=80


#BUILD DOCKER IMAGE
proxy=${http_proxy}
_no_proxy=${no_proxy} #Should be localhost,127.0.0.1,::1,santafe.gob.ar,santafe.gov.ar

#----------------------------------------------------------------------------------#
#                                 FUNCTIONS                                        #
#----------------------------------------------------------------------------------#
docker_clear_containers(){
	docker stop ${container_name} 2>/dev/null
	docker rm ${container_name} 2>/dev/null
}

docker_build_image(){
	echo "[DOCKER BUILD] - ${image_name}"
	local proxy_build_args=""
	if [ -n "$proxy" ] ; then
	 	echo "building with proxy args"
		proxy_build_args=" --build-arg HTTPS_PROXY=${proxy} \
					   --build-arg FTP_PROXY=${proxy} \
					   --build-arg http_proxy=${proxy} \
					   --build-arg https_proxy=${proxy} \
					   --build-arg ftp_proxy=${proxy} \
					   --build-arg no_proxy=${_no_proxy} "
	fi

	docker build --quiet -t ${image_name} ${proxy_build_args} .
}

docker_run_container(){
	echo "[DOCKER RUN] - ${container_name}"

	local proxy_options="" 
	local full_restart_options=""

	if [ -n "$proxy" ] ; then
		echo "Run with proxy options"
		proxy_options=" -e HTTP_PROXY=${proxy} \
		                -e HTTPS_PROXY=${proxy} \
		                -e FTP_PROXY=${proxy} \
		                -e http_proxy=${proxy} \
		                -e https_proxy=${proxy} \
		                -e ftp_proxy=${proxy} "
	fi

	if [ "$FULL_RESTART" = true ] ; then
		echo "Run with full restart options"
		full_restart_options=" -e PS_DEV_MODE=1 -e PS_INSTALL_AUTO=1 -e PS_ERASE_DB=1 " 
	fi

	local db_options="-e DB_SERVER=${mysql_container_name} \
		-e DB_USER=ps_user \
		-e DB_NAME=prestashop \
		-e DB_PASSWD=ps_password "

	
	if [ "$DRY_RUN" = true ] ; then
		printf "[ DRY RUN ] \n"
		printf "docker run -ti \n \
				\t --name ${container_name} \n \
				\t --hostname ${container_name} \n \
				\t --network ${container_db_net} \n \
				\t --mount source=prestashop-volume,target=/var/www/html \n \
   				\t ${db_options} \n \
				\t ${proxy_options} \n \
				\t ${full_restart_options} \n \
				\t -p ${host_external_port}:${container_external_port}\n \
				\t -d jduttweiler/prestashop:1.7 \n" | awk '$1=$1'
	else
		docker run -ti \
		--name ${container_name} \
		--hostname ${container_name} \
		--network ${container_db_net} \
		--mount source=prestashop-volume,target=/var/www/html \
		   ${db_options} \
	 	   ${proxy_options} \
	 	   ${full_restart_options} \
		-p ${host_external_port}:${container_external_port}\
		-d jduttweiler/prestashop:1.7
	fi

}



#----------------------------------------------------------------------------------#
#                                 MAIN                                             #
#----------------------------------------------------------------------------------#

docker_clear_containers
docker_build_image
docker_run_container

#docker network create ${container_db_net}
#docker network connect ${container_balancer_net} ${container_name}s
#Volume
#Create directory for the database
#docker volume create prestashop-volume