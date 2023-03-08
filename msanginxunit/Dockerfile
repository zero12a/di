## debian linux 11
# docker build -t msanginxunit .
# (포그라운드 실행/port없음) docker run -i -t -p 8888:8888 --name nginxunit msanginxunit
# (백그라운드 실행/port없음) docker run -i -t -d -p 8888:8888 --name nginxunit msanginxunit

FROM nginx/unit:1.29.0-php8.1

# step 2
ARG ENTRYKIT_VERSION=0.4.0
ARG APCU_VERSION=5.1.22
ARG REDIS_VERSION=5.1.1

# step 2
RUN apt-get update            
RUN apt-get install -y curl unzip wget sudo
RUN apt-get install libpq-dev python3-dev -y

# install opcache
RUN docker-php-ext-install opcache

# install pdo_mysql, pdo_postgresql
RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-install pgsql pdo_pgsql


ADD entrypoint.sh /entrypoint.sh
RUN chmod +x entrypoint.sh

ENTRYPOINT /entrypoint.sh 1    # Shell format
