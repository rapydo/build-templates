#!/bin/sh

set -e

cp /etc/nginx/adminer-${APP_MODE}.conf /etc/nginx/conf.d/adminer.conf

nginx

echo "NGINX started"
