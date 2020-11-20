#!/bin/sh

set -e

cp /etc/nginx/adminer-${APP_MODE}.conf /etc/nginx/conf.d/adminer.conf

echo "Starting NGINX"

exec nginx -g 'daemon off;'
