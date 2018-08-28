FROM prestashop/prestashop:1.7
LABEL maintainer="Jonatan Duttweiler <jduttweiler@santafe.gov.ar>"
COPY ./config /var/www/html/config
RUN apt-get update && apt-get install -y iputils-ping telnet nano lynx

