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
    tail -n 1000 -f $LOGS
    echo "Main WSGI/PROXY logging interrupted!"
    sleep infinity
fi

####################################
# sleep infinity
