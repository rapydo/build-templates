#!/bin/bash

LOGS=""
echo "Internal production startup"
echo ""

####################################
if [ -n "$UWSGI_MASTER" ]; then
    # home inside tmp
    export HOME=$MYUWSGI_HOME

    echo "Starting uwsgi"
    uwsgi --ini $UWSGI_MASTER

    echo ""
    LOGS="/var/log/uwsgi/*.log $LOGS"

elif [ -n "$UWSGI_EMPEROR" ]; then
    echo "Starting uwsgi in emperor/vassals mode"
    uwsgi --emperor $UWSGI_EMPEROR
    echo ""
fi

####################################
if [ -n "$NGINX_ACTIVE" ]; then
    echo "Starting nginx"
    service nginx start
    echo ""
    # LOGS="/var/log/nginx/*log $LOGS"
fi

echo $LOGS

####################################
if [ "$LOGS" != "" ]; then

    # # NOTE: a possibility to debug failure
    # # grep failed logs: 'no app loaded'
    # failure=$(grep "no app loaded" $LOGS)
    # if [ "$failure" != "" ]; then
    #     echo "FAILED. Trying to debug:"
    #     restapi launch
    # else
    #     tail -f $LOGS
    #     echo "There was a problem with uwsgi/nginx logs! Hanging."
    # fi

    echo ${LOGS}
    # Cut out uswgi logs from the output.
    # These logs are redundant if coupled with normal outputs from flask
    # To make correctly work tail -f with pipe the stdbuf -o0 is needed
    # stdbuf -o0 disables buffering of the output stream and data is output immediately
    tail -n 1000 -f $LOGS | stdbuf -o0 grep -v "^\[pid: [0-9]\+|app: [0-9]\+|req: "
    echo "Main WSGI/PROXY logging interrupted!"
    sleep infinity
fi

####################################
# sleep infinity
