#!/bin/bash
set -e

if [[ ! -t 0 ]]; then
    /bin/ash /etc/banner.sh
fi

DEVID=$(id -u $APIUSER)
if [ "$DEVID" != "$CURRENT_UID" ]; then
    echo "Fixing uid of user $APIUSER from $DEVID to $CURRENT_UID..."
    usermod -u $CURRENT_UID $APIUSER
fi

GROUPID=$(id -g $APIUSER)
if [ "$GROUPID" != "$CURRENT_GID" ]; then
    echo "Fixing gid user $APIUSER from $GROUPID to $CURRENT_GID..."
    groupmod -og $CURRENT_GID $APIUSER
fi

# Defaults
if [ -z APP_MODE ]; then
    APP_MODE="development"
fi

# fix permissions on the main development folder
chown $APIUSER $CODE_DIR

if [ "$APP_MODE" == 'production' ]; then

    HOME=$CODE_DIR su -p $APIUSER -c 'restapi bot'

else
    echo "Development mode. You can start your bot by executing the command: restapi bot"
fi

sleep infinity
