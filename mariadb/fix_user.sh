#!/bin/bash
set -e

if [[ ! -t 0 ]]; then
    /bin/bash /etc/banner.sh
fi

MYSQL_USER="mysql"

DEVID=$(id -u "$MYSQL_USER")
if [ "$DEVID" != "$CURRENT_UID" ]; then
    echo "Fixing uid of user ${MYSQL_USER} from $DEVID to $CURRENT_UID..."
    usermod -u "$CURRENT_UID" "$MYSQL_USER"
fi

GROUPID=$(id -g $MYSQL_USER)
if [ "$GROUPID" != "$CURRENT_GID" ]; then
    echo "Fixing gid of user $MYSQL_USER from $GROUPID to $CURRENT_GID..."
    groupmod -og "$CURRENT_GID" "$MYSQL_USER"
fi
