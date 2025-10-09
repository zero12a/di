## debian linux 10
# docker build -t msaws .
# (포그라운드 실행/port없음) docker run -i -t -p 8050:80 --name ws msaws
# (백그라운드 실행/port없음) docker run -i -t -d -p 8050:80 --name ws2 msaws

# (백그라운드 실행/내PC개발)
# docker run -i -t -d -p 8050:80 \
# -v /Users/zeroone/Documents/docker/common:/data/www/common \
# -v /Users/zeroone/Documents/docker/w.s:/data/www/w.s \
# --name ws msaws

 docker run -i -t -d -p 8051:80 -p 8052:8052 \
 -v /Users/zeroone/Documents/docker/common:/data/www/common \
 -v /Users/zeroone/Documents/docker/o.s:/data/www/o.s \
 -v /Users/zeroone/Documents/docker/w.s:/data/www/w.s \
 --name os2 msaws:200115


# (php 패키지 정상설치확인) php -m | grep swoole

##############################################
## install os package
##############################################
FROM php:7.4-cli

# step 2
ARG ENTRYKIT_VERSION=0.4.0
ARG APCU_VERSION=5.1.18
ARG REDIS_VERSION=5.1.1
ARG SWOOLE_VERSION=4.4.14
ARG SWOOLE_ASYNC_VERSION=4.4.14

# step 2
RUN apt-get update            
RUN apt-get install -y curl unzip wget sudo

# Install debug tool (vi:bim, ps:procps, netstat:net-tools)
RUN apt-get install -y vim telnet procps net-tools

# install redis
WORKDIR /root
RUN pecl install redis-${REDIS_VERSION} \
    && docker-php-ext-enable redis

# install mysqli
RUN docker-php-ext-install mysqli

# install opcache
RUN docker-php-ext-install opcache

# install composer
RUN curl -sS https://getcomposer.org/installer | php  
RUN mv composer.phar /usr/bin/composer

# 엔트리킷 환경변수템플릿
WORKDIR /data
RUN wget https://github.com/progrium/entrykit/releases/download/v${ENTRYKIT_VERSION}/entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz
RUN tar -xvzf entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz
RUN rm entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz
RUN mv entrykit /usr/local/bin
RUN entrykit --symlink

# local mem cache apcu
RUN pecl install apcu-${APCU_VERSION} && docker-php-ext-enable apcu

# swoole install(type1 : this is swoole-async install error.)
# RUN pecl install swoole-${SWOOLE_VERSION} && docker-php-ext-enable swoole

# swoole install(type2 : this is src compile)
WORKDIR /data
RUN wget -O swoole-v${SWOOLE_VERSION}.tar.gz https://github.com/swoole/swoole-src/archive/v${SWOOLE_VERSION}.tar.gz
RUN tar -xvzf swoole-v${SWOOLE_VERSION}.tar.gz
WORKDIR /data/swoole-src-${SWOOLE_VERSION}
RUN /usr/local/bin/phpize
RUN ./configure
RUN make -j 4
RUN sudo make install
RUN docker-php-ext-enable swoole
#RUN rm -rf swoole-v${SWOOLE_VERSION}.tar.gz

# swoole-async base hiredis

# swoole-async install
WORKDIR /data
RUN wget -O ext-async-v${SWOOLE_ASYNC_VERSION}.tar.gz https://github.com/swoole/ext-async/archive/v${SWOOLE_ASYNC_VERSION}.tar.gz
RUN tar -xvzf ext-async-v${SWOOLE_ASYNC_VERSION}.tar.gz
WORKDIR /data/ext-async-${SWOOLE_ASYNC_VERSION}
RUN /usr/local/bin/phpize
RUN ./configure
RUN make -j 4
RUN sudo make install
RUN docker-php-ext-enable swoole_async
#RUN rm -rf ext-async-v${SWOOLE_ASYNC_VERSION}.tar.gz

##############################################
## config os
##############################################
# time  set seoul
RUN rm -f /etc/localtime
RUN ln -s /usr/share/zoneinfo/Asia/Seoul /etc/localtime


##############################################
## make folder
##############################################
# make www root folder
#RUN mkdir /data //뭔지 모르겠으나 이미 이 폴더는 존재해서 폴더 생성 불필요
RUN mkdir /data/www

# make log folder
RUN mkdir /data/www/log
RUN chmod 777 /data/www/log

# install lib
RUN mkdir /data/www/lib
RUN mkdir /data/www/lib/php


##############################################
## install app-libs package
##############################################
WORKDIR /data/www/lib/php
# predis library install
RUN composer require predis/predis
# swolle library install
RUN composer require swoole/library


##############################################
## install apps package
##############################################
# down common source
WORKDIR /data/www
RUN wget https://github.com/zero12a/common/archive/master.zip
RUN unzip master.zip
RUN mv common-master/ common/
RUN rm master.zip

##############################################
## down apps source
##############################################
WORKDIR /data/www
RUN wget https://github.com/zero12a/ws/archive/master.zip
RUN unzip master.zip
RUN mv ws-master/ w.s/
RUN rm master.zip


##############################################
## application env
##############################################

### env define
# php incConfig apps
ENV LIB_PATH_REDIS "/data/www/lib/php/vendor/predis/predis/autoload.php"
ENV REDIS_HOST "172.17.0.1"
ENV REDIS_PORT 1234
ENV REDIS_CONFIG_ID "CONFIG_CG"

# entry
# conf make conf
ENTRYPOINT [ \
    "render", \
        "/data/www/common/include/incConfig.php", \
        "--", \
    "/usr/local/bin/php", \
        "/data/www/w.s/index.php" \
]

# 단일 명령일때
# CMD cron -f
