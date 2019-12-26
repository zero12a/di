#!/bin/bash
cd /data/www/oauth2-demo-php/web

printf "\n\nStarting PHP daemon...\n\n"
php -S localhost:8080 & php -S localhost:8081
