FROM prestashop/prestashop:1.7
LABEL maintainer="Jonatan Duttweiler <jduttweiler@santafe.gov.ar>"
COPY ./parameters.php /var/www/html/app/config/
RUN apt-get update && apt-get install -y iputils-ping telnet nano lynx locate
RUN updatedb

RUN echo "127.0.0.1 docker.conaiisi2018.prestashop.com" >> /etc/hosts
