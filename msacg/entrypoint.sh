#!/bin/bash

echo "Starting php-fpm..."
exec php-fpm

echo "Starting nginx..."
exec $(which nginx) start


