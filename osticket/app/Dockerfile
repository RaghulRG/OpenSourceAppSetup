FROM ubuntu:22.04

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y curl wget apache2 php8.1 libapache2-mod-php php-mysql php-cgi php-fpm php-cli php-curl php-gd php-imap php-mbstring php-pear php-intl php-apcu php-common php-bcmath unzip && \
    rm -rf /var/lib/apt/lists/*

RUN version=$(curl -s https://raw.githubusercontent.com/osTicket/osTicket/develop/WHATSNEW.md | head -1 | awk {'print$2'}) && \
        cd /var/www/html && \
        wget https://github.com/osTicket/osTicket/releases/download/${version}/osTicket-${version}.zip && \
        unzip osTicket-${version}.zip && \
        mv upload osticket && \
        chown -R www-data:www-data /var/www/html/osticket && \
        chmod -R 775 /var/www/html/osticket && \
        mv /var/www/html/osticket/include/ost-sampleconfig.php /var/www/html/osticket/include/ost-config.php && \
        rm -rf /var/www/html/osTicket-*.zip scripts

RUN echo "\
<VirtualHost *:80>\n\
    ServerName osticket.example.com\n\
    ServerAdmin admin@localhost\n\
    DocumentRoot /var/www/html/osticket\n\
\n\
    <Directory /var/www/html/osticket>\n\
        Require all granted\n\
        Options FollowSymlinks\n\
        AllowOverride All\n\
    </Directory>\n\
\n\
    ErrorLog \${APACHE_LOG_DIR}/osticket.error.log\n\
    CustomLog \${APACHE_LOG_DIR}/osticket.access.log combined\n\
</VirtualHost>\n\
" > /etc/apache2/sites-available/osticket.conf

RUN a2ensite osticket.conf && \
    a2enmod rewrite

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_RUN_DIR /var/run/apache2

RUN mkdir -p ${APACHE_RUN_DIR}

EXPOSE 80

VOLUME /var/www/html

CMD ["apache2", "-D", "FOREGROUND"]
