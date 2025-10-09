## debian linux 10
# docker build -t msard .
# (포그라운드 실행/배포) docker run -i -t -p 8080:80 --name rd msard
# (백그라운드 실행/배포) docker run -i -t -d -p 8080:80 --name rd msard

# (백그라운드 실행/내PC개발)

# step 1 (php:7.4-fpm is debian linux)
FROM php:7.4-fpm

# step 2
ARG APCU_VERSION=5.1.22
ARG ENTRYKIT_VERSION=0.4.0
ARG GUZZLEHTTP_VERSION=7.3

##############################################
## install os package
##############################################
# step 2
WORKDIR /root
RUN apt-get update            
RUN apt-get install -y curl unzip nginx wget sudo libpq-dev cron
# sudo : batch log file is target user owner.

# Install debug tool (vi:bim, ps:procps, netstat:net-tools)
RUN apt-get install -y vim telnet procps net-tools

#ldap설치  (apt-get install -y libldap2-dev)

RUN apt-get install -y libldap2-dev

#executor failed running [/bin/sh -c apt-get install openldap-dev]: exit code: 100
#RUN apt-get install openldap-dev


RUN docker-php-ext-install ldap && docker-php-ext-enable ldap

# step 3
RUN curl -sS https://getcomposer.org/installer | php  
RUN mv composer.phar /usr/bin/composer

# mysqli
RUN docker-php-ext-install mysqli

# step 4
RUN apt-get install -y zlib1g-dev && apt-get install -y libzip-dev
RUN docker-php-ext-install zip

##############################################
## config os
##############################################
# time  set seoul
RUN rm -f /etc/localtime
RUN ln -s /usr/share/zoneinfo/Asia/Seoul /etc/localtime



##############################################
## make folder
##############################################
RUN mkdir /data
RUN mkdir /data/www
RUN mkdir /data/www/lib
RUN mkdir /data/www/lib/php
# make log folder
RUN mkdir /data/www/log
RUN chmod 777 /data/www/log
# make source folder
RUN mkdir /data/c.g/
RUN mkdir /data/c.g/CG
RUN chmod 777 /data/c.g/CG

##############################################
## install apps package
##############################################
# install download lib

WORKDIR /data/www/lib/php
RUN composer require monolog/monolog && \
  composer require predis/predis && \
  composer require ezyang/htmlpurifier && \
  composer require phpoffice/phpexcel && \
  composer require guzzlehttp/guzzle:^${GUZZLEHTTP_VERSION}

#캐쉬폴더 777권한 변경
RUN chmod 777 /data/www/lib/php/vendor/ezyang/htmlpurifier/library/HTMLPurifier/DefinitionCache/Serializer 

# crontab add
WORKDIR /data/www
RUN wget https://raw.githubusercontent.com/zero12a/di/master/msard/crontab.txt
RUN crontab /data/www/crontab.txt


# 엔트리킷 환경변수템플릿
WORKDIR /data
RUN wget https://github.com/progrium/entrykit/releases/download/v${ENTRYKIT_VERSION}/entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz
RUN tar -xvzf entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz
RUN rm entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz
RUN mv entrykit /usr/local/bin
RUN entrykit --symlink

# local mem cache apc
RUN pecl install apcu-${APCU_VERSION} && docker-php-ext-enable apcu

# redis.so
RUN pecl install redis && docker-php-ext-enable redis

# install pdo_mysql, pdo_postgresql
RUN docker-php-ext-install pdo_mysql

# install opcache
RUN docker-php-ext-install opcache

# install pdo_postgresql
RUN docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql
RUN docker-php-ext-install pgsql pdo_pgsql

# exif (이미지 타입 알기 함수)
RUN docker-php-ext-install exif && docker-php-ext-enable exif

##############################################
## install apps config
##############################################
# php.ini 가져오기
WORKDIR /usr/local/etc/php
RUN wget -O php.ini https://raw.githubusercontent.com/zero12a/di/master/msard/php.ini?new

# nginx
# conf copy
WORKDIR /etc/nginx/
RUN mv nginx.conf nginx.conf.default
RUN wget https://raw.githubusercontent.com/zero12a/di/master/msard/nginx.conf.tmpl

# php-fpm www.conf
# conf copy
WORKDIR /usr/local/etc/php-fpm.d/
RUN mv www.conf www.conf.default
RUN mv zz-docker.conf zz-docker.conf.default
RUN wget https://raw.githubusercontent.com/zero12a/di/master/msard/www.conf.tmpl

# down entrypoint.sh
WORKDIR /
RUN wget https://raw.githubusercontent.com/zero12a/di/master/msard/entrypoint.sh
RUN ["chmod", "+x", "/entrypoint.sh"]




##############################################
## application
##############################################
# step 5
# RUN cd /var/www/html

WORKDIR /data/www
RUN wget https://github.com/zero12a/rd/archive/master.zip
RUN unzip master.zip
RUN mv rd-master/ r.d/
RUN rm master.zip

# step 6
# common download
WORKDIR /data/www
RUN wget https://github.com/zero12a/common/archive/master.zip
RUN unzip master.zip
RUN mv common-master/ common/
RUN rm master.zip

# make demo source download
WORKDIR /data/www/c.g
RUN wget https://github.com/zero12a/ds/archive/master.zip
RUN unzip master.zip
RUN mv ds-master/ CG/
RUN rm master.zip


##############################################
## application env
##############################################
### env define
# nginx
ENV FASTCGI_PASS "unix:/var/run/php-fpm.sock"
# php fpm
ENV PHPFPM_LISTEN "/var/run/php-fpm.sock"
# php apps
ENV LIB_PATH_REDIS "/data/www/lib/php/vendor/autoload.php"
ENV REDIS_HOST "172.17.0.1"
ENV REDIS_PORT 1234
ENV REDIS_PASSWD "1234"
ENV REDIS_CONFIG_ID "CONFIG_RD"

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
    "/entrypoint.sh" \
]
