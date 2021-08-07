#!/bin/sh

set -e

if [[ ! -t 0 ]]; then
    /bin/ash /etc/banner.sh
fi

cp /etc/nginx/adminer-${APP_MODE}.conf /etc/nginx/http.d/adminer.conf

nginx

echo "NGINX started"
