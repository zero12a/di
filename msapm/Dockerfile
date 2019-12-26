## debian linux 10
# docker build -t msapm .
# docker build -t msapm:TAG .
# (포그라운드 실행/배포) docker run -i -t -p 8060:80 --name pm msapm
# (백그라운드 실행/배포) docker run -i -t -d -p 8060:80 --name pm msapm
# (백그라운드 실행/배포) docker run -i -t -d -p 8060:80 --name pm msapm:TAG

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

# mysqli
RUN docker-php-ext-install mysqli

# step 4
RUN apt-get install -y zlib1g-dev && apt-get install -y libzip-dev
RUN docker-php-ext-install zip

# step 5
# RUN cd /var/www/html
RUN mkdir /data
RUN mkdir /data/www
WORKDIR /data/www
RUN wget https://files.phpmyadmin.net/phpMyAdmin/4.9.2/phpMyAdmin-4.9.2-all-languages.zip
RUN unzip phpMyAdmin-*.zip
RUN mv phpMyAdmin-4.9.2-all-languages/ p.m/
RUN rm phpMyAdmin-*.zip

# phpmyadmin config
WORKDIR /data/www/p.m
RUN wget https://raw.githubusercontent.com/zero12a/di/master/msapm/config.inc.php.tmpl


# php.ini 가져오기
WORKDIR /usr/local/etc/php
RUN wget https://raw.githubusercontent.com/zero12a/di/master/msapm/php.ini

# nginx
# conf copy
WORKDIR /etc/nginx/
RUN mv nginx.conf nginx.conf.default
RUN wget https://raw.githubusercontent.com/zero12a/di/master/msapm/nginx.conf.tmpl

# php-fpm www.conf
# conf copy
WORKDIR /usr/local/etc/php-fpm.d/
RUN mv www.conf www.conf.default
RUN mv zz-docker.conf zz-docker.conf.default
RUN wget https://raw.githubusercontent.com/zero12a/di/master/msapm/www.conf.tmpl

# down entrypoint.sh
WORKDIR /
RUN wget https://raw.githubusercontent.com/zero12a/di/master/msapm/entrypoint.sh
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
# phpmyadmin
ENV SERVER_HOST "172.17.0.1"
ENV SERVER_PORT "3306"

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
    "render", \
        "/data/www/p.m/config.inc.php", \
        "--", \        
    "/entrypoint.sh" \
]