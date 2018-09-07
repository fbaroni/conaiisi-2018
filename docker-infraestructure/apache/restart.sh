#!/bin/bash

#proxy=${http_proxy}
#_no_proxy=${no_proxy} #Should be localhost,127.0.0.1,::1,santafe.gob.ar,santafe.gov.ar

#Container vars
image_name="jduttweiler/apache:sticky"
container_name="dart7"
container_network="db_network"

docker stop ${container_name}
docker rm ${container_name}

#BUILD DOCKER IMAGE
#docker build -t ${image_name} \
#        --build-arg HTTP_PROXY=${proxy} \
#        --build-arg HTTPS_PROXY=${proxy} \
#        --build-arg FTP_PROXY=${proxy} \
#        --build-arg http_proxy=${proxy} \
#        --build-arg https_proxy=${proxy} \
#        --build-arg ftp_proxy=${proxy} \
#        --build-arg no_proxy=${_no_proxy} .

docker build -t ${image_name} .

docker run -d \
	-P \
	--network=${container_network} \
	--name=${container_name} ${image_name}
