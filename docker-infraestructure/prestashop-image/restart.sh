#!/bin/bash
echo "RESTARTING DOCKER CONTAINER PRESTASHOP"

container_db_name=my-mysql
container_prestashop_name=my-prestashop
password_db=root
forwarded_port=8084
forwarded_db_port=3038
image_name=prestashop-conaiisi
network_prestashop=network_prestashop
network_balancer=network_prestashop

docker stop ${container_db_name} || true
docker rm ${container_db_name} || true

docker run -p ${forwarded_db_port}:3036 -v ${PWD}/mysql:/var/lib/mysql \
           --hostname=${container_db_name} \
           --name=${container_db_name} \
           -e MYSQL_ROOT_PASSWORD=${password_db}  \
           -d mysql:latest


#docker network create ${network_prestashop} 
docker network connect ${network_prestashop} ${container_db_name}
sudo chmod 777 -R mysql/
sudo chmod 777 -R www/
#docker run -ti --name some-prestashop --link some-mysql -e DB_SERVER=some-mysql -p 8080:80 -d prestashop/prestashop

docker stop ${container_prestashop_name} || true
docker rm ${container_prestashop_name} || true

proxy=${http_proxy}
_no_proxy=${no_proxy}

#BUILD DOCKER IMAGE
docker build \
        -t  ${image_name} \
        --build-arg HTTP_PROXY=${proxy} \
        --build-arg HTTPS_PROXY=${proxy} \
        --build-arg FTP_PROXY=${proxy} \
        --build-arg http_proxy=${proxy} \
        --build-arg https_proxy=${proxy} \
        --build-arg ftp_proxy=${proxy} \
        --build-arg no_proxy=${_no_proxy} .


docker run --hostname=${container_prestashop_name} \
           --link ${container_db_name} \
           --name=${container_prestashop_name} \
           --network=${network_prestashop} \
           -e DB_HOSTNAME=${container_db_name} \
           -v ${PWD}/www:/var/www/html \
           -e PS_INSTALL_AUTO=1 \
           -e PS_ERASE_DB=1 \
           -p ${forwarded_port}:80 \
           -d ${image_name}

echo "conectar a la red---";
docker network connect ${network_prestashop} ${container_prestashop_name}

echo "BASH";
docker exec -it ${container_prestashop_name} /bin/bash