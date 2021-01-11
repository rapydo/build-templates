#!/bin/bash
set -e

MONGO_USER="mongodb"

DEVID=$(id -u "${MONGO_USER}")
if [ "${DEVID}" != "${CURRENT_UID}" ]; then
    echo "Fixing uid of user ${MONGO_USER} from ${DEVID} to ${CURRENT_UID}..."
    usermod -u "$CURRENT_UID" "${MONGO_USER}"
fi

GROUPID=$(id -g ${MONGO_USER})
if [ "${GROUPID}" != "${CURRENT_GID}" ]; then
    echo "Fixing gid of user ${MONGO_USER} from ${GROUPID} to ${CURRENT_GID}..."
    groupmod -og "${CURRENT_GID}" "${MONGO_USER}"
fi

chown ${CURRENT_UID}:${CURRENT_GID} /docker-entrypoint-initdb.d/init-mongo.sh