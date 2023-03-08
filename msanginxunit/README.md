ARG APCU_VERSION=5.1.22

# local mem cache apc
RUN pecl install apcu-5.1.22 && docker-php-ext-enable apcu

# install redis
RUN pecl install redis-5.3.7 && docker-php-ext-enable redis

# install opcache
RUN docker-php-ext-install opcache

# install pdo_mysql, pdo_postgresql
RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-install pgsql pdo_pgsql