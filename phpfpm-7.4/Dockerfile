FROM php:7.2-fpm
RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
    && docker-php-ext-install -j$(nproc) iconv \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd

# docker build -t speedphp73cg .
# docker run -i -t -p 9000:9000 --name phpfpm73 speedphp73cg

# step 1
FROM php:7.3-fpm

# step 2
WORKDIR /root
RUN apt-get update            
RUN apt-get install -y curl vim wget

# step 3
RUN curl -sS https://getcomposer.org/installer | php  
RUN mv composer.phar /usr/bin/composer

# step 4
RUN apt-get install -y zlib1g-dev && apt-get install -y libzip-dev
RUN docker-php-ext-install zip

# step 5
# RUN cd /var/www/html
RUN wget https://raw.githubusercontent.com/zero12a/cg/master/cg_test.php
RUN cp cg_test.php /var/www/html/

# step 6
EXPOSE 9000
CMD ["php-fpm"]

