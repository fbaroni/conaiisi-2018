FROM httpd:2.4
LABEL maintainer="jonatanduttweiler@gmail.com"

#COPY CONF
COPY ./httpd.conf /usr/local/apache2/conf/
COPY ./proxy.conf /usr/local/apache2/conf/

RUN echo "127.0.0.1 docker.conaiisi2018.prestashop.com" >> /etc/hosts




