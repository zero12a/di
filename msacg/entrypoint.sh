#!/bin/bash

echo "Starting php-fpm..."
echo php-fpm

echo "Starting nginx..."
exec $(which nginx) start


