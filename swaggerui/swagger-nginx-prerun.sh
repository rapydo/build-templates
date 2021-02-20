#!/bin/sh

set -e
set -o allexport

# We pass to envsubst the list of env variables, to only replace existing variables
envsubst "$(env | cut -d= -f1 | sed -e 's/^/$/')" < /etc/nginx/adminer-${APP_MODE}.conf > /etc/nginx/nginx.conf

if [[ ${APP_MODE} == "production" ]];
then
    export URLS="[ { url: 'https://${DOMAIN}/api/specs', name: '${PROJECT_TITLE}' } ]"
else
    export URLS="[ { url: 'http://${DOMAIN}:${BACKEND_PORT}/api/specs', name: '${PROJECT_TITLE}' } ]"
fi
