#!/bin/bash

# even if !/bin/bash, it will be executed as /bin/sh, do not use [[ ... ]]
if [ ${IS_CELERY_CONTAINER} ]; then
    echo "$(python3 --version) - Celery $(celery --version)"
else
    echo "$(python3 --version) - $(flask --version | grep Flask)"
fi