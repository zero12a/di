## debian linux 10
# docker build  -t msabatch .
# (포그라운드 실행/배포) docker run -i -t  --name batch msabatch
# (백그라운드 실행/배포) docker run -i -t -d  --name batch msabatch

# step 1
FROM php:8-cli-alpine

# 패키지 찾기 : apk search gcc | grep ^gcc

ARG APCU_VERSION=5.1.20
ARG ENTRYKIT_VERSION=0.4.0
ARG GUZZLEHTTP_VERSION=7.3

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

#ldap설치
RUN apk add openldap-dev
RUN docker-php-ext-install ldap && docker-php-ext-enable ldap

#whereis는 util-linux에 
RUN apk add --update util-linux

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
## make folder
##############################################
RUN mkdir /data
RUN mkdir /data/www
RUN mkdir /data/www/lib
RUN mkdir /data/www/lib/php
# make folder
#RUN mkdir /data/www/b.t

# make log folder
RUN mkdir /data/www/log
RUN chmod 777 /data/www/log



#폴더 이동
WORKDIR /data/www/lib/php

#guzzlehttp ( workerman require pcntl.so )
RUN composer require guzzlehttp/guzzle:^${GUZZLEHTTP_VERSION} && \
composer require mustache/mustache && \
composer require lavary/crunz && \
composer require workerman/workerman && \
composer require workerman/redis && \
composer require monolog/monolog && \
composer require predis/predis && \
composer require phpmailer/phpmailer 

RUN docker-php-ext-configure pcntl --enable-pcntl && docker-php-ext-install pcntl

#RUN docker-php-ext-install openssl && docker-php-ext-enable openssl


##############################################
## config os
##############################################
# time  set seoul
RUN cp /usr/share/zoneinfo/Asia/Seoul /etc/localtime
RUN echo "Asia/Seoul" > /etc/timezone




#RUN chmod 777 /data/www/log

##############################################
## application
##############################################
# step 5
# RUN cd /var/www/html

WORKDIR /data/www
RUN wget https://github.com/zero12a/bt/archive/master.zip
RUN unzip master.zip
RUN mv bt-master/ b.t/
RUN chown www-data:www-data /data/www/b.t
RUN rm master.zip

# step 6
# common download
WORKDIR /data/www
RUN wget https://github.com/zero12a/common/archive/master.zip
RUN unzip master.zip
RUN mv common-master/ common/
RUN rm master.zip


##############################################
## install apps package
##############################################
# install download lib

# crontab add
WORKDIR /data/www
RUN wget https://raw.githubusercontent.com/zero12a/di/master/msabatch/crontab.txt
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

# redis.so
RUN pecl install redis && docker-php-ext-enable redis

# install pdo_mysql, pdo_postgresql
RUN docker-php-ext-install pdo_mysql
#동작안함 RUN apk del --no-cache .build-dependencies

# install pdo_postgresql
RUN docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql
RUN docker-php-ext-install pgsql pdo_pgsql
#동작안함 RUN apk del --no-cache .build-dependencies

##############################################
## install apps config
##############################################
# 사용자 변경하기 (서비스 설정파일 및 app소스 일일)
# php.ini 가져오기
RUN wget -O /usr/local/etc/php/php.ini https://raw.githubusercontent.com/zero12a/di/master/msabatch/php.ini


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


##############################################
## application env
##############################################
### env define

# php apps
ENV LIB_PATH_REDIS "/data/www/lib/php/vendor/autoload.php"
ENV REDIS_HOST "172.17.0.1"
ENV REDIS_PORT 1234
ENV REDIS_CONFIG_ID "CONFIG_CG"

# conf make conf
##############################################
## start
##############################################
CMD [ "crond", "-f"]
