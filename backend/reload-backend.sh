#!/bin/bash

if [ "$APP_MODE" == "production" ]; then
    # Can't use pidof because it is execute via python
    PID=$(pgrep gunicorn | head -1)
    echo "Reloading gunicorn (PID #${PID})..."
    kill -s SIGHUP ${PID}
else

    echo "Reloading Flask..."
    touch ${PYTHON_PATH}/restapi/__main__.py
fi
