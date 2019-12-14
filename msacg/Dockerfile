## debian linux 10
# docker build -t msacg .
# (포그라운드 실행/배포) docker run -i -t -p 8090:80 --name cg msacg
# (백그라운드 실행/배포) docker run -i -t -d -p 8090:80 --name cg msacg

# (백그라운드 실행/내PC개발)
# docker run -i -t -d \
# -v /Users/zeroone/Documents/docker/common:/data/www/common \
# -v /Users/zeroone/Documents/docker/c.g:/data/www/c.g \
# -p 8090:80 --name cg msacg

# step 1
FROM php:7.4-fpm

# step 2
WORKDIR /root
RUN apt-get update            
RUN apt-get install -y curl unzip nginx wget

# Install debug tool (vi:bim, ps:procps, netstat:net-tools)
RUN apt-get install -y vim telnet procps net-tools

# step 3
RUN curl -sS https://getcomposer.org/installer | php  
RUN mv composer.phar /usr/bin/composer

# step 4
RUN apt-get install -y zlib1g-dev && apt-get install -y libzip-dev
RUN docker-php-ext-install zip

# step 5
# RUN cd /var/www/html
RUN mkdir /data
RUN mkdir /data/www
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

# install download lib
RUN mkdir /data/www/lib
RUN mkdir /data/www/lib/php
WORKDIR /data/www/lib/php
RUN composer require monolog/monolog
RUN composer require predis/predis
RUN composer require aws/aws-sdk-php
RUN composer require ezyang/htmlpurifier
RUN composer require phpoffice/phpexcel

# install download custom lib
WORKDIR /data/www/lib/php
RUN wget https://github.com/zero12a/cg/raw/master/libcustom/PHP-SQL-Parser.zip
RUN unzip PHP-SQL-Parser.zip

# make log folder
RUN mkdir /data/www/log
RUN chmod 777 /data/www/log


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


# 엔트리킷 환경변수템플릿
WORKDIR /data
RUN wget https://github.com/progrium/entrykit/releases/download/v0.4.0/entrykit_0.4.0_Linux_x86_64.tgz
RUN tar -xvzf entrykit_0.4.0_Linux_x86_64.tgz
RUN rm entrykit_0.4.0_Linux_x86_64.tgz
RUN mv entrykit /usr/local/bin
RUN entrykit --symlink


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
