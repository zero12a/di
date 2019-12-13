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
    && pecl install xdebug-2.8.1 \
    && docker-php-ext-enable redis xdebug

# step 4
RUN apt-get install -y zlib1g-dev && apt-get install -y libzip-dev
RUN docker-php-ext-install zip

# entry
CMD ["cron"]
