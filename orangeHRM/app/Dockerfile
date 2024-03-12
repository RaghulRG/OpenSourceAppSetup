FROM ubuntu:22.04

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y curl wget apache2 php8.1 libapache2-mod-php php-mysql php-gd php-cli php-curl php-xml php-zip php-mbstring php-json php-intl php-ldap unzip


RUN version=$(curl -s https://raw.githubusercontent.com/orangehrm/orangehrm/main/build/build.xml | grep -oP 'name="version" value="\K[^"]+') && \
        cd /var/www/html && \
        wget https://excellmedia.dl.sourceforge.net/project/orangehrm/stable/${version}/orangehrm-${version}.zip  && \
        unzip orangehrm-${version}.zip  && \
        mv orangehrm-${version} orangehrm  && \
        chmod -R 775 orangehrm && \
        rm -rf /var/www/html/logo.png /var/www/html/orangehrm-*.zip /var/www/html/orangehrm-quick-start-guide.html && \
        chown -R www-data:www-data /var/www/html/orangehrm

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_RUN_DIR /var/run/apache2

RUN mkdir -p ${APACHE_RUN_DIR}

#WORKDIR /var/www/html

EXPOSE 80

VOLUME /var/www/html

CMD ["apache2", "-D", "FOREGROUND"]

