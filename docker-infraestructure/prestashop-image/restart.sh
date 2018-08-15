#!/bin/bash
echo "RESTARTING DOCKER CONTAINER PRESTASHOP"

container_db_name=my-mysql
container_prestashop_name=my-prestashop
password_db=root
forwarded_port=8084
forwarded_db_port=3038
image_name=prestashop-conaiisi

docker stop ${container_db_name} || true
docker rm ${container_db_name} || true

docker run -d -p ${forwarded_db_port}:3036 -v ${PWD}/mysql:/var/lib/mysql \
           --hostname=${container_db_name} \
           --name=${container_db_name} \
           -e MYSQL_ROOT_PASSWORD=${password_db}  \
           -d mysql:latest

#docker network connect lamp_network ${container_name}
sudo chmod 777 -R mysql/

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


docker run -d --hostname=${container_prestashop_name} \
           --link ${container_db_name} \
           --name=${container_prestashop_name} \
           -v ${PWD}/www:/var/www/html \
           -e PS_INSTALL_AUTO=1 \
           -e PS_ERASE_DB=1 \
           -p ${forwarded_port}:80 \
           -d prestashop/prestashop


docker exec ${container_prestashop_name} chmod 777 -R /var/www/html/
docker exec ${container_prestashop_name} service apache2 restart
docker exec -it ${container_prestashop_name} /bin/bash