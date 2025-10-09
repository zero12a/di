#!/bin/sh

echo "\n\nStarting PHP daemon...\n\n"
php-fpm --daemonize

echo "Starting Nginx...\n\n"
/usr/sbin/nginx 
