#!/bin/sh


printf "\n\nStarting PHP daemon...\n\n"
php-fpm --daemonize

printf "\n\nStarting crontab...\n\n"
crond -f 