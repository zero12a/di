#!/bin/bash

printf "\n\nStarting PHP daemon...\n\n"
php-fpm --daemonize

printf "\n\nStarting cron daemon...\n\n"
/usr/sbin/cron

printf "Starting Nginx...\n\n"
service nginx start 
