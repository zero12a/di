#!/bin/bash

echo "Starting nginx..."
exec $(which nginx) start &

echo "Starting php-fpm..."
echo php-fpm
