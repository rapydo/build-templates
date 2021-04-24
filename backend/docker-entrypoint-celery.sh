#!/bin/bash
set -e

export CONTAINER_ID=$(head -1 /proc/self/cgroup|cut -d/ -f3 | cut -c1-12)
export IS_CELERY_CONTAINER=1

if [[ ! -t 0 ]]; then
    /bin/bash /etc/banner.sh
fi

DEVID=$(id -u $APIUSER)
if [ "$DEVID" != "$CURRENT_UID" ]; then
    echo "Fixing uid of user $APIUSER from $DEVID to $CURRENT_UID..."
    usermod -u $CURRENT_UID $APIUSER
fi

GROUPID=$(id -g $APIUSER)
if [ "$GROUPID" != "$CURRENT_GID" ]; then
    echo "Fixing gid of user $APIUSER from $GROUPID to $CURRENT_GID..."
    groupmod -og $CURRENT_GID $APIUSER
fi

# fix permissions of flower db dir
if [ -d "$CELERYUI_DBDIR" ]; then
    chown -R $APIUSER $CELERYUI_DBDIR
fi

# fix permissions of celery beat pid dir
if [ -d "/pids" ]; then
    chown -R $APIUSER /pids
fi

echo "waiting for services"

HOME=$CODE_DIR su -p $APIUSER -c 'restapi wait'

# echo "Requested command: $@"

# $@
# exit 0

exec gosu $APIUSER $@ &
pid="$!"
# no success with wait...
# trap "echo Sending SIGTERM to process ${pid} && kill -SIGTERM ${pid} && wait {$pid}" INT TERM
trap "echo Sending SIGTERM to process ${pid} && kill -SIGTERM ${pid} && sleep 5" TERM
trap "echo Sending SIGINT to process ${pid} && kill -SIGINT ${pid} && sleep 5" INT
wait
