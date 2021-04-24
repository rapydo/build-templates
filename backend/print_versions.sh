#!/bin/bash

if [[ ${IS_CELERY_CONTAINER} ]]; then
    echo "$(python3 --version) - Celery $(celery --version)"
else
    echo "$(python3 --version) - $(flask --version | grep Flask)"
fi