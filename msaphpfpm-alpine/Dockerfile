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

# cron, vi, procps(ps) 은 처음부터 설치되어 있음, 
# libpq-dev는 postgresql-dev로 변경
# telnet은 busybox-extras로 변경
apk add curl 
apk add unzip nginx wget 
apk add sudo git 
apk add cron 
apk add postgresql-dev

apk add net-tools
apk add busybox-extras

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
