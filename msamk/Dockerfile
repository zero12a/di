## debian linux 10
# docker build -t msamk .
# (포그라운드 실행/배포) docker run -i -t -p 8060:80 --name mk msamk
# (백그라운드 실행/배포) docker run -i -t -d -p 8060:80 --name mk msamk

# (백그라운드 실행/내PC개발)
docker run -i -t -d \
 -v /Users/zeroone/Documents/docker/common:/data/www/common \
 -v /Users/zeroone/Documents/docker/m.k:/data/www/m.k \
 -v /Users/zeroone/Documents/docker/c.g/CG:/data/www/c.g/CG \
 -p 8060:80 --name mk msamk

# step 1
FROM php:7.4-fpm

# step 2
ARG APCU_VERSION=5.1.18
ARG ENTRYKIT_VERSION=0.4.0

##############################################
## install os package
##############################################
# step 2
WORKDIR /root
RUN apt-get update            
RUN apt-get install -y curl unzip nginx wget cron sudo git
# sudo : batch log file is target user owner.

# Install debug tool (vi:bim, ps:procps, netstat:net-tools)
RUN apt-get install -y vim telnet procps net-tools

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

# www-data 사용자전환su 가능하게 쉘 변경하기(nologin to /bin/bash)
RUN chsh -s /bin/bash www-data

##############################################
## make folder
##############################################
RUN mkdir /data
RUN mkdir /data/www
RUN mkdir /data/www/lib
RUN mkdir /data/www/lib/php
# makeer folder
RUN mkdir /data/www/c.g
RUN mkdir /data/www/c.g/CG
RUN chmod 777 /data/www/c.g/CG
# make log folder
RUN mkdir /data/www/log
RUN chmod 777 /data/www/log


##############################################
## install apps package
##############################################
# install download lib

WORKDIR /data/www/lib/php
RUN composer require monolog/monolog
RUN composer require predis/predis
RUN composer require aws/aws-sdk-php
RUN composer require ezyang/htmlpurifier
#캐쉬폴더 777권한 변경
RUN chmod 777 /data/www/lib/php/vendor/ezyang/htmlpurifier/library/HTMLPurifier/DefinitionCache/Serializer 
RUN composer require phpoffice/phpexcel

# crontab add
WORKDIR /data/www
RUN wget https://raw.githubusercontent.com/zero12a/di/master/msamk/crontab.txt
RUN cp /data/www/crontab.txt /etc/cron.d/crontab-watcher
RUN chmod 0644 /etc/cron.d/crontab-watcher
RUN crontab /etc/cron.d/crontab-watcher

# 엔트리킷 환경변수템플릿
WORKDIR /data
RUN wget https://github.com/progrium/entrykit/releases/download/v${ENTRYKIT_VERSION}/entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz
RUN tar -xvzf entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz
RUN rm entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz
RUN mv entrykit /usr/local/bin
RUN entrykit --symlink

# local mem cache apc
RUN pecl install apcu-${APCU_VERSION} && docker-php-ext-enable apcu



##############################################
## install apps config
##############################################
# php.ini 가져오기
WORKDIR /usr/local/etc/php
RUN wget https://raw.githubusercontent.com/zero12a/di/master/msamk/php.ini

# nginx
# conf copy
WORKDIR /etc/nginx/
RUN mv nginx.conf nginx.conf.default
RUN wget https://raw.githubusercontent.com/zero12a/di/master/msamk/nginx.conf.tmpl

# php-fpm www.conf
# conf copy
WORKDIR /usr/local/etc/php-fpm.d/
RUN mv www.conf www.conf.default
RUN mv zz-docker.conf zz-docker.conf.default
RUN wget https://raw.githubusercontent.com/zero12a/di/master/msamk/www.conf.tmpl

# down entrypoint.sh
WORKDIR /
RUN wget https://raw.githubusercontent.com/zero12a/di/master/msamk/entrypoint.sh
RUN ["chmod", "+x", "/entrypoint.sh"]




##############################################
## application
##############################################
# step 5
# RUN cd /var/www/html

WORKDIR /data/www
RUN wget https://github.com/zero12a/mk/archive/master.zip
RUN unzip master.zip
RUN mv mk-master/ m.k/
RUN rm master.zip

# step 6
# common download
WORKDIR /data/www
RUN wget https://github.com/zero12a/common/archive/master.zip
RUN unzip master.zip
RUN mv common-master/ common/
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
ENV LIB_PATH_REDIS "/data/www/lib/php/vendor/predis/predis/autoload.php"
ENV REDIS_HOST "172.17.0.1"
ENV REDIS_PORT 1234
ENV REDIS_CONFIG_ID "CONFIG_CG"
ENV REDIS_DATASOURCE_ID "DATASOURCE_CG"

# port open
EXPOSE 80

# conf make conf
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
