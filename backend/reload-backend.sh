#!/bin/bash

if [ "$HOSTNAME" == "backend-server" ]; then

    if [ "$APP_MODE" == "production" ]; then
        # Can't use pidof because it is execute via python
        PID=$(pgrep -f /usr/local/bin/gunicorn | head -1)
        echo "Reloading gunicorn (PID #${PID})..."
        kill -s SIGHUP ${PID}
    else

        echo "Reloading Flask..."
        touch ${PYTHON_PATH}/restapi/__main__.py
    fi
elif [ "$HOSTNAME" == "flower" ]; then
    echo "Not implemented yet"
elif [ "$HOSTNAME" == "celery-beat" ]; then
    echo "Not implemented yet"
elif [ "$HOSTNAME" == "telegram-bot" ]; then
    echo "Not implemented yet"
else
    PID=$(pgrep -f /usr/local/bin/celery | head -1)
    echo "Reloading celery (PID #${PID})..."
    kill -s SIGHUP ${PID}
fi