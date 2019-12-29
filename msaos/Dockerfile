# this is oauth2 server
## debian linux 10
# docker build -t msaos .
# (포그라운드 실행/port없음) docker run -i -t -p 8082:8080 -p 8081:8081 --name os msaos
# (백그라운드 실행/port없음) docker run -i -t -d -p 8082:8080 -p 8081:8081 --name os msaos


# (백그라운드 실행/내PC개발)
# docker run -i -t -d \
# -v /Users/zeroone/Documents/docker/common:/data/www/common \
# -v /Users/zeroone/Documents/docker/o.s:/data/www/o.s \
# --name os msaos


FROM php:7.4-cli

# step 1 make folder
RUN mkdir /data
RUN mkdir /data/www

# step 2
RUN apt-get update            
RUN apt-get install -y curl unzip wget git

# Install debug tool (vi:bim, ps:procps, netstat:net-tools)
RUN apt-get install -y vim telnet procps net-tools

# install redis xdebug
WORKDIR /root
RUN pecl install redis-5.1.1 \
    && docker-php-ext-enable redis

# mysqli
RUN docker-php-ext-install mysqli

# install opcache
RUN docker-php-ext-install opcache

# make log folder
RUN mkdir /data/www/log
RUN chmod 777 /data/www/log


# install composer
RUN curl -sS https://getcomposer.org/installer | php  
RUN mv composer.phar /usr/bin/composer


# down demo source N oauth2-server-php lib install
WORKDIR /data/www
RUN git clone git://github.com/bshaffer/oauth2-demo-php.git
WORKDIR /data/www/oauth2-demo-php
RUN composer install


# down entrypoint.sh
WORKDIR /
RUN wget https://raw.githubusercontent.com/zero12a/di/master/msaos/entrypoint.sh
RUN ["chmod", "+x", "/entrypoint.sh"]


# 엔트리킷 환경변수템플릿
WORKDIR /data
RUN wget https://github.com/progrium/entrykit/releases/download/v0.4.0/entrykit_0.4.0_Linux_x86_64.tgz
RUN tar -xvzf entrykit_0.4.0_Linux_x86_64.tgz
RUN rm entrykit_0.4.0_Linux_x86_64.tgz
RUN mv entrykit /usr/local/bin
RUN entrykit --symlink

### env define
# php incConfig apps


# entry
# conf make conf

# old
#ENTRYPOINT [ \
#    "/entrypoint.sh", \
#]

# new
ENTRYPOINT ["/usr/local/bin/php","-S","0.0.0.0:8080"]
CMD ["-t","/data/www/oauth2-demo-php/web"]
