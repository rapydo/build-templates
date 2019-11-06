#!/bin/bash
set -e

#######################################
#                                     #
#             Entrypoint!             #
#                                     #
#######################################

# Defaults
if [ -z APP_MODE ]; then
    APP_MODE="debug"
fi

env > /tmp/.env
node /rapydo/config-env.ts

node /rapydo/merge.js

# --production to install only dependencies e not devDependencies
npm install

# npm cache clean

if [ "$APP_MODE" == 'production' ]; then

	exec npm run build

elif [ "$APP_MODE" == 'debug' ]; then

	exec npm start


elif [ "$APP_MODE" == 'cypress' ]; then

	exec npm run start-cypress

else
	echo "Unknown APP_MODE: [${APP_MODE}]"
fi
