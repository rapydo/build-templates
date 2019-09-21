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

node /rapydo/utility/merge.js

# --production to install only dependencies e not devDependencies
npm --prefix $MODULE_PATH install

# npm cache clean

export PATH=$PATH:$MODULE_PATH/node_modules/.bin
export NODE_PATH=$MODULE_PATH/node_modules

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
