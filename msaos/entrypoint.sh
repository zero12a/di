#!/bin/bash
cd /data/www/oauth2-demo-php/web

printf "\n\nStarting PHP daemon...\n\n"

php -S 0.0.0.0:8080 & php -S 0.0.0.0:8081
#php -S 0.0.0.0:8081 -t /data/www/oauth2-demo-php/web
