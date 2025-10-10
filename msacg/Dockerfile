## debian linux 10
# docker build -t msacg .
# (포그라운드 실행/배포) docker run -i -t -p 8090:80 --name cg msacg
# (백그라운드 실행/배포) docker run -i -t -d -p 8090:80 --name cg msacg
# (백그라운드 실행/배포) docker run -i -t -d -p 8090:80 --name cg msacg


# (백그라운드 실행/내PC개발) docker run -i -t -d \
-v /Users/yoman/Documents/docker/cg:/data/www/c.g \
-v /Users/yoman/Documents/docker/common:/data/www/common \
-p 8090:80 --name cg msacg


# step 1
FROM php:8.4-fpm

# step 2
ARG APCU_VERSION=5.1.27


##############################################
## install os package
##############################################
# step 2
WORKDIR /root
RUN apt-get update            
RUN apt-get install -y curl unzip nginx wget cron sudo mariadb-client libpq-dev
# sudo : batch log file is target user owner.
# mariadb-client : mysql-client no install, mariadb-client good install
# libpq-dev : postgre bib
 
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



##############################################
## install apps package
##############################################
# install download lib

WORKDIR /data/www/lib/php
RUN composer require monolog/monolog
RUN composer require predis/predis
RUN composer require aws/aws-sdk-php
RUN composer require ezyang/htmlpurifier
RUN composer require phpoffice/phpexcel
#aws 의존성때문에 7.0사용해야함.
RUN composer require guzzlehttp/guzzle:^7.0

# install download custom lib
WORKDIR /data/www/lib/php
RUN wget https://github.com/zero12a/cg/raw/master/libcustom/PHP-SQL-Parser.zip
RUN unzip PHP-SQL-Parser.zip
RUN rm PHP-SQL-Parser.zip && rm -rf __MACOSX


# 엔트리킷 환경변수템플릿
WORKDIR /data
RUN wget https://github.com/progrium/entrykit/releases/download/v0.4.0/entrykit_0.4.0_Linux_x86_64.tgz
RUN tar -xvzf entrykit_0.4.0_Linux_x86_64.tgz
RUN rm entrykit_0.4.0_Linux_x86_64.tgz
RUN mv entrykit /usr/local/bin
RUN entrykit --symlink

# local mem cache apc
RUN pecl install apcu-${APCU_VERSION} && docker-php-ext-enable apcu

# install pdo_mysql, pdo_postgresql
RUN docker-php-ext-install pdo_mysql

# install pdo_postgresql
RUN docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql
RUN docker-php-ext-install pgsql pdo_pgsql

# redis.so
RUN pecl install redis && docker-php-ext-enable redis

##############################################
## install apps config
##############################################
# crontab add
WORKDIR /data/www
RUN wget https://raw.githubusercontent.com/zero12a/di/master/msacg/crontab.txt
RUN cp /data/www/crontab.txt /etc/cron.d/crontab-watcher
RUN chmod 0644 /etc/cron.d/crontab-watcher
RUN crontab /etc/cron.d/crontab-watcher

# php.ini 가져오기
WORKDIR /usr/local/etc/php
RUN wget https://raw.githubusercontent.com/zero12a/di/master/msacg/php.ini

# nginx
# conf copy
WORKDIR /etc/nginx/
RUN mv nginx.conf nginx.conf.default
RUN wget https://raw.githubusercontent.com/zero12a/di/master/msacg/nginx.conf.tmpl

# php-fpm www.conf
# conf copy
WORKDIR /usr/local/etc/php-fpm.d/
RUN mv www.conf www.conf.default
RUN mv zz-docker.conf zz-docker.conf.default
RUN wget https://raw.githubusercontent.com/zero12a/di/master/msacg/www.conf.tmpl

# down entrypoint.sh
WORKDIR /
RUN wget https://raw.githubusercontent.com/zero12a/di/master/msacg/entrypoint.sh
RUN ["chmod", "+x", "/entrypoint.sh"]




##############################################
## application
##############################################
# step 5
# RUN cd /var/www/html

WORKDIR /data/www
RUN wget https://github.com/zero12a/cg/archive/master.zip
RUN unzip master.zip
RUN mv cg-master/ c.g/
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
ENV LIB_PATH_REDIS "/data/www/lib/php/vendor/autoload.php"
ENV REDIS_HOST "172.17.0.1"
ENV REDIS_PORT 1234
ENV REDIS_PASSWD "1234"
ENV REDIS_CONFIG_ID "CONFIG_CG"

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
