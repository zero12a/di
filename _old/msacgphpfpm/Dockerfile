## debian linux 10
# docker build -t msacgphpfpm .
# (포그라운드 실행) docker run -i -t -p 9100:9000 --name cgphpfpm msacgphpfpm
# (백그라운드 실행) docker run -i -t -d -p 9100:9000 --name cgphpfpm msacgphpfpm

# step 1
FROM php:7.3-fpm

# step 2
WORKDIR /root
RUN apt-get update            
RUN apt-get install -y curl unzip

# Install debug tool
RUN apt-get install -y vim wget telnet procps

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
RUN mkdir /data/www/c.g/log
RUN chmod 777 /data/www/c.g/log

# install cron
# cron add

# 엔트리킷 환경변수템플릿
WORKDIR /data
RUN wget https://github.com/progrium/entrykit/releases/download/v0.4.0/entrykit_0.4.0_Linux_x86_64.tgz
RUN tar -xvzf entrykit_0.4.0_Linux_x86_64.tgz
RUN rm entrykit_0.4.0_Linux_x86_64.tgz
RUN mv entrykit /usr/local/bin
RUN entrykit --symlink

# env define
ENV LIB_PATH_REDIS "/data/www/lib/php/vendor/predis/predis/autoload.php"
ENV REDIS_HOST 172.17.0.1
ENV REDIS_PORT 1234
ENV REDIS_CONFIG_ID "CONFIG_CG"

# conf make conf
ENTRYPOINT [ \
    "render", \
        "/data/www/c.g/incConfig.php", \
        "--" \
]


# test page
# RUN cp cg_test.php /var/www/html/


# step 6
EXPOSE 9000
CMD ["php-fpm"]

