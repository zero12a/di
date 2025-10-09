## debian linux 10
# docker build  -t msaall .
# (포그라운드 실행/배포) docker run -i -t -p 8030:80 --name all msaall
# (백그라운드 실행/배포) docker run -i -t -d -p 8030:80 --name all msaall



# step 1
FROM php:8-fpm-alpine

# 패키지 찾기 : apk search gcc | grep ^gcc

ARG APCU_VERSION=5.1.27
ARG ENTRYKIT_VERSION=0.4.0
ARG GUZZLEHTTP_VERSION=7.10

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

# postgre
RUN apk add postgresql-dev

#ldap설치
RUN apk add openldap-dev
RUN docker-php-ext-install ldap && docker-php-ext-enable ldap

#whereis는 util-linux에 
RUN apk add --update util-linux

RUN curl -sS https://getcomposer.org/installer | php  
RUN mv composer.phar /usr/bin/composer

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
#RUN chmod 777 /data/www/log


##############################################
## install apps package
##############################################

WORKDIR /data/www/lib/php
RUN composer require monolog/monolog && \
  composer require predis/predis && \
  composer require ezyang/htmlpurifier && \
  composer require phpoffice/phpexcel && \
  composer require workerman/workerman && \
  composer require workerman/redis && \
  composer require guzzlehttp/guzzle:^${GUZZLEHTTP_VERSION}


# mysqli
RUN docker-php-ext-install mysqli
#동작안함 RUN apk del --no-cache .build-dependencies

# zip설치 zlib1g-dev는 불필요
RUN docker-php-ext-install zip
#동작안함 RUN apk del --no-cache .build-dependencies

# exif (이미지 타입 알기 함수)
RUN docker-php-ext-install exif && docker-php-ext-enable exif

#event driven framework ( workerman require pcntl.so )
RUN docker-php-ext-configure pcntl --enable-pcntl && docker-php-ext-install pcntl

#postgre
RUN docker-php-ext-install exif 
RUN docker-php-ext-install pdo_pgsql



##############################################
## install apps package
##############################################
# install download lib

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

# redis.so
RUN pecl install redis && docker-php-ext-enable redis

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
RUN wget -O /usr/local/etc/php/php.ini https://raw.githubusercontent.com/zero12a/di/master/msaall/php.ini

# nginx
RUN wget -O /etc/nginx/nginx.conf.tmpl https://raw.githubusercontent.com/zero12a/di/master/msaall/nginx.conf.tmpl

# nginx upstream folder auth change (alpine linux error : "[crit] 24#24: *151 open() /var/lib/nginx/~" )
RUN chown -R www-data:www-data /var/lib/nginx

# php-fpm www.conf
# conf copy
WORKDIR /usr/local/etc/php-fpm.d/
RUN mv www.conf www.conf.default
RUN mv zz-docker.conf zz-docker.conf.default
RUN wget -O www.conf.tmpl https://raw.githubusercontent.com/zero12a/di/master/msaall/www.conf.tmpl

##############################################
## application
##############################################


##############################################
## 불필요 패키지/데이터 삭제하기
##############################################
RUN apk del build-base tzdata autoconf libzip-dev postgresql-dev
RUN pecl clear-cache
#RUN apk del .build-dependencies
#RUN apk del .phpize-deps-configure
RUN docker-php-source delete



# down entrypoint.sh
RUN wget -O /entrypoint.sh https://raw.githubusercontent.com/zero12a/di/master/msaall/entrypoint.sh?22
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
EXPOSE 80 81 82 83 84 85 86 87 88 89

# conf make conf
##############################################
## start
##############################################
ENTRYPOINT [ \
    "render", \
        "/usr/local/etc/php-fpm.d/www.conf", \
        "--", \
    "render", \
        "/data/www/common/include/incConfig.php", \
        "--", \
    "render", \
        "/etc/nginx/nginx.conf", \
        "--", \
    "/entrypoint.sh" \
]
