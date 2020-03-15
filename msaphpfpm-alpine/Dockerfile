## debian linux 10
# docker build  -t msaphpfpm-alpine .
# (포그라운드 실행/배포) docker run -i -t -p 8040:80 --name ds msaphpfpm-alpine
# (백그라운드 실행/배포) docker run -i -t -d -p 8040:80 --name ds msaphpfpm-alpine

# (백그라운드 실행/내PC개발)
#docker run -i -t -d \
# -v /Users/zeroone/Documents/docker/common:/data/www/common \
# -v /Users/zeroone/Documents/docker/d.s:/data/www/d.s \
# -p 8040:80 --name ds msads

# step 1
FROM php:7.4-fpm-alpine

# 패키지 찾기 : apk search gcc | grep ^gcc
# step 2
ARG APCU_VERSION=5.1.18
ARG ENTRYKIT_VERSION=0.4.0

##############################################
## install os package
##############################################
# cron, vi, procps(ps) 은 처음부터 설치되어 있음, 
# libpq-dev는 postgresql-dev로 변경
# telnet은 busybox-extras로 변경
RUN apk update
RUN apk add curl unzip nginx wget sudo git postgresql-dev net-tools busybox-extras

RUN curl -sS https://getcomposer.org/installer | php  
RUN mv composer.phar /usr/bin/composer

# mysqli
RUN docker-php-ext-install mysqli


# 아래 2개 설치 제외, zlib1g-dev
apk add zlib-dev

RUN docker-php-ext-install zip


##############################################
## make folder
##############################################
RUN mkdir /data
RUN mkdir /data/www
RUN mkdir /data/www/lib
RUN mkdir /data/www/lib/php
# make folder
RUN mkdir /data/www/d.s
RUN chown www-data:www-data /data/www/d.s
# make log folder
RUN mkdir /data/www/log
RUN chmod 777 /data/www/log



##############################################
## install apps package
##############################################
# install download lib

RUN composer require monolog/monolog
RUN composer require predis/predis
RUN composer require aws/aws-sdk-php
RUN composer require ezyang/htmlpurifier
#캐쉬폴더 777권한 변경
RUN chmod 777 /data/www/lib/php/vendor/ezyang/htmlpurifier/library/HTMLPurifier/DefinitionCache/Serializer 
RUN composer require phpoffice/phpexcel



# crontab add
WORKDIR /data/www
RUN wget https://raw.githubusercontent.com/zero12a/di/master/msads/crontab.txt
RUN cp /data/www/crontab.txt /etc/crontabs/crontab-watcher
RUN chmod 0644 /etc/crontabs/crontab-watcher
RUN crontab /etc/crontabs/crontab-watcher


# 엔트리킷 환경변수템플릿
WORKDIR /data
RUN wget https://github.com/progrium/entrykit/releases/download/v${ENTRYKIT_VERSION}/entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz
RUN tar -xvzf entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz
RUN rm entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz
RUN mv entrykit /usr/local/bin
RUN entrykit --symlink


# local mem cache apc
RUN pecl install apcu-${APCU_VERSION} && docker-php-ext-enable apcu

# install pdo_mysql, pdo_postgresql
RUN docker-php-ext-install pdo_mysql

# install pdo_postgresql
RUN docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql
RUN docker-php-ext-install pgsql pdo_pgsql


##############################################
## install apps config
##############################################

# php.ini 가져오기
WORKDIR /usr/local/etc/php
RUN wget https://raw.githubusercontent.com/zero12a/di/master/msads/php.ini

# nginx
# conf copy
WORKDIR /etc/nginx/
RUN mv nginx.conf nginx.conf.default
RUN wget https://raw.githubusercontent.com/zero12a/di/master/msads/nginx.conf.tmpl

# php-fpm www.conf
# conf copy
WORKDIR /usr/local/etc/php-fpm.d/
RUN mv www.conf www.conf.default
RUN mv zz-docker.conf zz-docker.conf.default
RUN wget https://raw.githubusercontent.com/zero12a/di/master/msads/www.conf.tmpl

# down entrypoint.sh
WORKDIR /
RUN wget https://raw.githubusercontent.com/zero12a/di/master/msads/entrypoint.sh
RUN ["chmod", "+x", "/entrypoint.sh"]