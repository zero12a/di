## debian linux 10
# docker build -t msalc .
# (포그라운드 실행/port없음) docker run -i -t --name lc msalc
# (백그라운드 실행/port없음) docker run -i -t -d --name lc msalc

FROM php:7.4-cli

# step 2
RUN apt-get update            
RUN apt-get install -y curl unzip nginx cron wget

# Install debug tool (vi:bim, ps:procps, netstat:net-tools)
RUN apt-get install -y vim telnet procps net-tools

# install redis xdebug
WORKDIR /root
RUN pecl install redis-5.1.1 \
    && docker-php-ext-enable redis

# down lc source
RUN mkdir /data && mkdir /data/www
WORKDIR /data/www
RUN wget https://github.com/zero12a/lc/archive/master.zip
RUN unzip master.zip
RUN mv lc-master/ l.c/
RUN rm master.zip

# down common source
WORKDIR /data/www
RUN wget https://github.com/zero12a/common/archive/master.zip
RUN unzip master.zip
RUN mv common-master/ common/
RUN rm master.zip

# make log folder
RUN mkdir /data/www/log
RUN chmod 777 /data/www/log

# cron tab add
WORKDIR /data/www
RUN wget https://raw.githubusercontent.com/zero12a/di/master/msalc/crontab.txt
RUN cp /data/www/crontab.txt /etc/cron.d/crontab-watcher
RUN chmod 0644 /etc/cron.d/crontab-watcher
RUN crontab /etc/cron.d/crontab-watcher

# install composer
RUN curl -sS https://getcomposer.org/installer | php  
RUN mv composer.phar /usr/bin/composer

# install lib
RUN mkdir /data/www/lib
RUN mkdir /data/www/lib/php
WORKDIR /data/www/lib/php
RUN composer require predis/predis

# 엔트리킷 환경변수템플릿
WORKDIR /data
RUN wget https://github.com/progrium/entrykit/releases/download/v0.4.0/entrykit_0.4.0_Linux_x86_64.tgz
RUN tar -xvzf entrykit_0.4.0_Linux_x86_64.tgz
RUN rm entrykit_0.4.0_Linux_x86_64.tgz
RUN mv entrykit /usr/local/bin
RUN entrykit --symlink

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
    "cron", \
        "-f" \
]

# 단일 명령일때
# CMD cron -f
