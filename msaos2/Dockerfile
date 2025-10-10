## debian linux 10
# docker build  -t msaos .
# (포그라운드 실행/배포) docker run -i -t -p 18052:80 --name os msaos
# (백그라운드 실행/배포) docker run -i -t -d -p 18052:80 --name os msaos

# step 1
FROM php:7.4.26-fpm-alpine3.14

# 패키지 찾기 : apk search gcc | grep ^gcc

ARG APCU_VERSION=5.1.21
ARG ENTRYKIT_VERSION=0.4.0

##############################################2
## install os package
##############################################
# cron, vi, procps(ps) 은 처음부터 설치되어 있음, 
# libpq-dev는 postgresql-dev로 변경
# telnet은 busybox-extras로 변경
# tzdata는 타이존데이터
# apuc컴파일 위해 autoconf, build-base(gcc) 필요
RUN apk update && apk upgrade
RUN apk add curl unzip nginx wget sudo git postgresql-dev net-tools busybox-extras autoconf libzip-dev tzdata bash

#whereis는 util-linux에 
RUN apk add --update util-linux

#ldap설치
RUN apk add openldap-dev
RUN docker-php-ext-install ldap && docker-php-ext-enable ldap

RUN curl -sS https://getcomposer.org/installer | php  
RUN mv composer.phar /usr/bin/composer

# mysqli
RUN docker-php-ext-install mysqli
#동작안함 RUN apk del --no-cache .build-dependencies

# zip설치 zlib1g-dev는 불필요
RUN docker-php-ext-install zip
#동작안함 RUN apk del --no-cache .build-dependencies

# exif (이미지 타입 알기 함수)
RUN docker-php-ext-install exif && docker-php-ext-enable exif

##############################################
## config os
##############################################
# time  set seoul
RUN cp /usr/share/zoneinfo/Asia/Seoul /etc/localtime
RUN echo "Asia/Seoul" > /etc/timezone


##############################################
## make folder
##############################################
RUN mkdir /data
RUN mkdir /data/www
RUN mkdir /data/www/lib
RUN mkdir /data/www/lib/php
# make folder
RUN mkdir /data/www/o.s
RUN chown www-data:www-data /data/www/o.s


##############################################
## install apps package
##############################################
# install download lib
WORKDIR /data/www/lib/php
RUN composer require monolog/monolog
RUN composer require predis/predis

# crontab add
WORKDIR /data/www
RUN wget https://raw.githubusercontent.com/zero12a/di/master/msads/crontab.txt
RUN cp /data/www/crontab.txt /etc/crontabs/crontab-watcher
RUN chmod 0644 /etc/crontabs/crontab-watcher
RUN crontab /etc/crontabs/crontab-watcher

# 엔트리킷 환경변수템플릿
WORKDIR /data
RUN wget -O entrykit.tgz https://github.com/progrium/entrykit/releases/download/v${ENTRYKIT_VERSION}/entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz
RUN tar -xvzf entrykit.tgz
RUN rm entrykit.tgz
RUN mv entrykit /usr/local/bin
RUN entrykit --symlink


# local mem cache apc
#RUN apk add php7-pecl-apcu
# gcc컴파일러(build-base)
RUN apk add --update --no-cache --virtual .build-dependencies $PHPIZE_DEPS
RUN pecl install apcu-${APCU_VERSION} 
RUN docker-php-ext-enable apcu

# install pdo_mysql, pdo_postgresql
RUN docker-php-ext-install pdo_mysql
#동작안함 RUN apk del --no-cache .build-dependencies

# install opcache
RUN docker-php-ext-install opcache

# install pdo_postgresql
RUN docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql
RUN docker-php-ext-install pgsql pdo_pgsql
#동작안함 RUN apk del --no-cache .build-dependencies

##############################################
## install apps config
##############################################
# 사용자 변경하기 (서비스 설정파일 및 app소스 일일)
# php.ini 가져오기
RUN wget -O /usr/local/etc/php/php.ini https://raw.githubusercontent.com/zero12a/di/master/msaos2/php.ini

# nginx
RUN wget -O /etc/nginx/nginx.conf.tmpl https://raw.githubusercontent.com/zero12a/di/master/msaos2/nginx.conf.tmpl

# nginx upstream folder auth change (alpine linux error : "[crit] 24#24: *151 open() /var/lib/nginx/~" )
RUN chown -R www-data:www-data /var/lib/nginx

# php-fpm www.conf
# conf copy
WORKDIR /usr/local/etc/php-fpm.d/
RUN mv www.conf www.conf.default
RUN mv zz-docker.conf zz-docker.conf.default
RUN wget -O www.conf.tmpl https://raw.githubusercontent.com/zero12a/di/master/msaos2/www.conf.tmpl

##############################################
## application
##############################################
# step 5
# RUN cd /var/www/html

WORKDIR /data/www
RUN wget https://github.com/zero12a/os/archive/master.zip
RUN unzip master.zip
RUN mv os-master/* o.s/
RUN rm -rf master.zip os-master

# step 6
# common download
WORKDIR /data/www
RUN wget https://github.com/zero12a/common/archive/master.zip
RUN unzip master.zip
RUN mv common-master/ common/
RUN rm master.zip

##############################################
## 불필요 패키지/데이터 삭제하기
##############################################
RUN apk del build-base tzdata autoconf libzip-dev postgresql-dev
RUN pecl clear-cache
#RUN apk del .build-dependencies
#RUN apk del .phpize-deps-configure
RUN docker-php-source delete



# down entrypoint.sh
RUN wget -O /entrypoint.sh https://raw.githubusercontent.com/zero12a/di/master/msaos2/entrypoint.sh
RUN ["chmod", "+x", "/entrypoint.sh"]





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
ENV REDIS_CONFIG_ID "CONFIG_CG"

# port open
EXPOSE 80

# conf make conf
##############################################
## start
##############################################
ENTRYPOINT [ \
    "render", \
        "/usr/local/etc/php-fpm.d/www.conf", \
        "--", \
    "render", \
        "/etc/nginx/nginx.conf", \
        "--", \
    "/entrypoint.sh" \
]
