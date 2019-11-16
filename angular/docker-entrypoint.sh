#!/bin/bash
set -e

#######################################
#                                     #
#             Entrypoint!             #
#                                     #
#######################################

DEVID=$(id -u node)
if [ "$DEVID" != "$CURRENT_UID" ]; then
    echo "Fixing user node uid from $DEVID to $CURRENT_UID..."
    usermod -u $CURRENT_UID $APIUSER
fi

id
su - node
id

# Defaults
if [ -z APP_MODE ]; then
    APP_MODE="debug"
fi

exec gosu node env > /tmp/.env
exec gosu node node /rapydo/config-env.ts

exec gosu node node /rapydo/merge.js

# --production to install only dependencies e not devDependencies
exec gosu node npm install

# npm cache clean

if [ "$APP_MODE" == 'production' ]; then

	exec gosu node npm run build

elif [ "$APP_MODE" == 'debug' ]; then

	exec gosu node npm start


elif [ "$APP_MODE" == 'cypress' ]; then

	exec gosu node npm run start-cypress

else
	echo "Unknown APP_MODE: [${APP_MODE}]"
fi
