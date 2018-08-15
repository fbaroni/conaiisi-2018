FROM prestashop/prestashop:1.7-7.2-apache
LABEL maintainer="fbaroni@gmail.com"
#Run installation
RUN php /var/www/html/index_cli.php --domain=$hostname --db_server=$DB_HOSTNAME --db_user=root --db_password=root --db_name=db --db_clear=1 --language=a --firstname=a --lastname=a --password=admin  --email=a@gmail.com --newsletter=0 chdir=/var/www/html/install

# - name: install prestashop using cli
#   command: /usr/bin/php index_cli.php --domain={{ vagrant_host }} --db_server={{ vagrant_db_ip }} --db_user={{ mysql_db_user }} --db_password={{ mysql_db_password }} --db_name={{ mysql_db_name }} --db_clear=1 --language={{ prestashop_language }} --timezone={{ prestashop_timezone }} --country={{ prestashop_country }} --firstname={{ prestashop_firstname }} --lastname={{ prestashop_lastname }} --password={{ prestashop_password }}  --email={{ prestashop_email }} --newsletter=0 chdir=/var/www/html/install
#   ignore_errors: yes
#   no_log: yes

# - name: remove prestashop install directory
#   file:
#     path: /var/www/html/install
#     state: absent

# - name: set permissions
#   file:
#     path: /var/www/html
#     mode: 0777
#     recurse: yes
#     state: directory
#     owner: "vagrant"
#     group: "vagrant"
