#!/bin/sh

printf "\n\nStarting crontab...\n\n"
crond -f &

printf "\n\nStarting PHP daemon...\n\n"
php-fpm --daemonize

printf "Starting Nginx...\n\n"
service nginx start 
