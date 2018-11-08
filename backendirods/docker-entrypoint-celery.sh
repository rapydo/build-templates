#!/bin/bash
set -e

# fix permissions of flower db dir
if [ -d "$CELERYUI_DBDIR" ]; then
    chown -R $APIUSER $CELERYUI_DBDIR
fi

echo "waiting for services"
eval 'restapi wait'

echo "Requested command: $@"

# $@
# exit 0

$@ &                                                                                                                   
pid="$!"                                                                                                                 
# no success with wait...
# trap "echo Sending SIGTERM to process ${pid} && kill -SIGTERM ${pid} && wait {$pid}" INT TERM
trap "echo Sending SIGTERM to process ${pid} && kill -SIGTERM ${pid} && sleep 5" INT TERM
wait
