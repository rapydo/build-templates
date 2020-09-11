#!/bin/bash
set -e

#######################################
#                                     #
#             Entrypoint!             #
#                                     #
#######################################

NODE_USER="node"
NODE_HOME=$(eval echo ~$NODE_USER)

DEVID=$(id -u "$NODE_USER")
if [ "$DEVID" != "$CURRENT_UID" ]; then
    echo "Fixing uid of user ${NODE_USER} from $DEVID to $CURRENT_UID..."
    usermod -u "$CURRENT_UID" "$NODE_USER"
fi

GROUPID=$(id -g $NODE_USER)
if [ "$GROUPID" != "$CURRENT_GID" ]; then
    echo "Fixing gid of user $NODE_USER from $GROUPID to $CURRENT_GID..."
    groupmod -og "$CURRENT_GID" "$NODE_USER"
fi


echo "Running as ${NODE_USER} (uid $(id -u ${NODE_USER}))"

# Defaults
if [ -z APP_MODE ]; then
    APP_MODE="development"
fi

run_as_node() {
    HOME="${NODE_HOME}" su -p "${NODE_USER}" -c "${1}"
}

if [ "$APP_MODE" == 'test' ]; then
    export BACKEND_HOST=${CYPRESS_BACKEND_HOST}
fi

run_as_node "env > /tmp/.env"
run_as_node "node /rapydo/config-env.ts"
run_as_node "node /rapydo/merge.js"
# Very rough workaround to prevent:
# error TS2688: Cannot find type definition file for 'node'.
run_as_node "cp -r /opt/node_modules/@types node_modules/"
run_as_node "reload-types"

if [ "$APP_MODE" == 'production' ]; then

	run_as_node "yarn install --production"
    sed -i "s/[\"|']use strict[\"|']/;/g" node_modules/exceljs/dist/exceljs.js
	run_as_node "yarn run courtesy"
	run_as_node "yarn run build -- --base-href https://${BASE_HREF}${FRONTEND_PREFIX} --deleteOutputPath=false"
	run_as_node "yarn run gzip"

elif [ "$APP_MODE" == 'development' ]; then

	run_as_node "yarn install"
	run_as_node "yarn start"

elif [ "$APP_MODE" == 'test' ]; then

	sleep infinity

else
	echo "Unknown APP_MODE: ${APP_MODE}"
fi
