14-ago-2018
Para que el contenedor levante, necesita llegar a los balancer members, definidos en proxy.conf
Por el momento están definidos como worker1  y worker2, pero se les puede dar cualquier nombre.
Para que docker pueda hacer uso del dns por nombre del contenedor, es necesario que estos se encuentren
en la misma red. 
crear la red con
docker network create prestashop_network

El script restart asume que la red tiene el nombre anterior.
Al momento de crear los contenedores para prestashop, hay que conectarlos a la misma red, esto se puede
hacer con la opcion --network dentro del run (permite conectarlo solo a una red), o bien con el comando
docker network connect nombre_red nombre_container

---
