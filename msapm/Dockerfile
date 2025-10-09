## debian linux 10
# docker build -t msapm .
# docker build -t msapm:TAG .
# (포그라운드 실행/배포) docker run -i -t -p 8050:80 --name pm msapm
# (백그라운드 실행/배포) docker run -i -t -d -p 8050:80 --name pm msapm
# (백그라운드 실행/배포) docker run -i -t -d -p 8050:80 --name pm msapm:TAG

# step 1
FROM php:8.2-fpm

# step 2
ARG PHPMYADMIN_VERSION=5.2.3
ARG ENTRYKIT_VERSION=0.4.0

##############################################
## install os package
##############################################
# step 2
WORKDIR /root
RUN apt-get update            
RUN apt-get install -y curl unzip nginx wget

# Install debug tool (vi:bim, ps:procps, netstat:net-tools)
RUN apt-get install -y vim telnet procps net-tools

# step 3
RUN curl -sS https://getcomposer.org/installer | php  
RUN mv composer.phar /usr/bin/composer


##############################################
## make folder
##############################################
RUN mkdir /data
RUN mkdir /data/www
RUN chown www-data:www-data /data/www
RUN mkdir /data/www/lib
RUN mkdir /data/www/lib/php


##############################################
## install apps package
##############################################
# install download lib
WORKDIR /data/www/lib/php

# mysqli
RUN docker-php-ext-install mysqli

# install opcache
RUN docker-php-ext-install opcache

# step 4
RUN apt-get install -y zlib1g-dev && apt-get install -y libzip-dev
RUN docker-php-ext-install zip


# 엔트리킷 환경변수템플릿
WORKDIR /data
RUN wget https://github.com/progrium/entrykit/releases/download/v${ENTRYKIT_VERSION}/entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz
RUN tar -xvzf entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz
RUN rm entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz
RUN mv entrykit /usr/local/bin
RUN entrykit --symlink



##############################################
## config os
##############################################
# time  set seoul
RUN rm -f /etc/localtime
RUN ln -s /usr/share/zoneinfo/Asia/Seoul /etc/localtime




##############################################
## install middleware config
##############################################
# phpmyadmin config
# php.ini 가져오기
WORKDIR /usr/local/etc/php
RUN wget https://raw.githubusercontent.com/zero12a/di/master/msapm/php.ini

# nginx
# conf copy
WORKDIR /etc/nginx/
RUN mv nginx.conf nginx.conf.default
RUN wget https://raw.githubusercontent.com/zero12a/di/master/msapm/nginx.conf.tmpl

# php-fpm www.conf
# conf copy
WORKDIR /usr/local/etc/php-fpm.d/
RUN mv www.conf www.conf.default
RUN mv zz-docker.conf zz-docker.conf.default
RUN wget https://raw.githubusercontent.com/zero12a/di/master/msapm/www.conf.tmpl

# down entrypoint.sh
WORKDIR /
RUN wget https://raw.githubusercontent.com/zero12a/di/master/msapm/entrypoint.sh
RUN ["chmod", "+x", "/entrypoint.sh"]





##############################################
## install apps package
##############################################
# step 5
# RUN cd /var/www/html
USER www-data



WORKDIR /data/www
RUN wget https://files.phpmyadmin.net/phpMyAdmin/${PHPMYADMIN_VERSION}/phpMyAdmin-${PHPMYADMIN_VERSION}-all-languages.zip
RUN unzip phpMyAdmin-*.zip
RUN mv phpMyAdmin-${PHPMYADMIN_VERSION}-all-languages/ p.m/
RUN rm phpMyAdmin-*.zip
#RUN mkdir /data/www/p.m/tmp
#RUN chmod 777 /data/www/p.m/tmp

##############################################
## install apps config
##############################################
# phpmyadmin config
WORKDIR /data/www/p.m/
RUN wget https://raw.githubusercontent.com/zero12a/di/master/msapm/v5_config.inc.php.tmpl
RUN mv v5_config.inc.php.tmpl config.inc.php.tmpl


USER root

### env define
# nginx
ENV FASTCGI_PASS "unix:/var/run/php-fpm.sock"
# php fpm
ENV PHPFPM_LISTEN "/var/run/php-fpm.sock"
# phpmyadmin
ENV SERVER_HOST1 "172.17.0.1"
ENV SERVER_PORT1 "3306"

ENV SERVER_HOST2 "172.17.0.1"
ENV SERVER_PORT2 "4306"

ENV SERVER_HOST3 "172.17.0.1"
ENV SERVER_PORT3 "8306"


# port open
EXPOSE 80

# conf make conf
ENTRYPOINT [ \
    "render", \
        "/usr/local/etc/php-fpm.d/www.conf", \
        "--", \
    "render", \
        "/etc/nginx/nginx.conf", \
        "--", \
    "render", \
        "/data/www/p.m/config.inc.php", \
        "--", \        
    "/entrypoint.sh" \
]
