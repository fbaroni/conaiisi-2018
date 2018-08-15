#Esta es la opción TAL CUAL como está la versión oficial
#http://build.prestashop.com/news/prestashop-and-docker/ 
# y https://hub.docker.com/r/prestashop/prestashop/ SUPUESTAMENTE debería andar así con el PS_INSTALL_AUTO en 1 pero no
# ni siquiera anda el apache ! hay algo q obviamente no estoy viendo
#hardcodeado el nombre del contenedor de mysql
docker run -ti --name some-prestashop --link some-mysql -e PS_INSTALL_AUTO=1 -e DB_SERVER=my-mysql -p 8082:80 -d prestashop/prestashop