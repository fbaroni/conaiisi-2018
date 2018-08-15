#!/bin/bash
#Esta es la opción un poco más compleja pero tampoco...
#no arranca el contenedor de prestashop de manera correcta y directamente borre el dockerfile
echo "RESTARTING DOCKER CONTAINER PRESTASHOP"

container_db_name=my-mysql
container_prestashop_name=my-prestashop
password_db=root
forwarded_port=8085
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

docker run --hostname=${container_prestashop_name} \
           --link ${container_db_name} \
           --name=${container_prestashop_name} \
           --network=${network_prestashop} \
           -e DB_SERVER=${container_db_name} \
           -v ${PWD}/www:/var/www/html \
           -e PS_INSTALL_AUTO=1 \
           -e PS_ERASE_DB=1 \
           -e DB_USER=root \
           -e DB_PASSWORD=root \
           -p ${forwarded_port}:80 \
           -d prestashop/prestashop

docker network connect ${network_prestashop} ${container_prestashop_name}
docker exec  ${container_prestashop_name} service apache2 restart && sleep infinity
docker exec -it ${container_prestashop_name} /bin/bash