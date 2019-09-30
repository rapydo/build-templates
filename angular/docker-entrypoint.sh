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
node /rapydo/utility/config-env.ts

node /rapydo/utility/merge.js

# --production to install only dependencies e not devDependencies
npm install

# npm cache clean

if [ "$APP_MODE" == 'production' ]; then

	if [ "$ENABLE_AOT" == 'True' ]; then
		exec npm run build-aot
	else
		exec npm run build
	fi

elif [ "$APP_MODE" == 'debug' ]; then

	exec npm start

else
	echo "Unknown APP_MODE: [${APP_MODE}]"
fi
