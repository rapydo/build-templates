#!/bin/sh

set -e

# We pass to envsubst the list of env variables, to only replace existing variables
envsubst "$(env | cut -d= -f1 | sed -e 's/^/$/')" < /etc/nginx/adminer-${APP_MODE}.conf > etc/nginx/conf.d/adminer.conf

echo "Starting NGINX"

exec nginx -g 'daemon off;'
