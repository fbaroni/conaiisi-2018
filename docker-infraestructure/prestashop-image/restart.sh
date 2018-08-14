#!/bin/bash
echo "RESTARTING DOCKER CONTAINER PRESTASHOP"

container_db_name=my-mysql
container_prestashop_name=my-prestashop
password_db=root
forwarded_port=8084
forwarded_db_port=3038

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

docker run -d --hostname=${container_prestashop_name} \
           --link ${container_db_name} \
           --name=${container_prestashop_name} \
           -e DB_SERVER=some-mysql=${container_db_name}  \
           -e PS_INSTALL_AUTO=1 \
           -p ${forwarded_port}:80 \
           -d prestashop/prestashop

docker exec -it ${container_prestashop_name} /bin/bash