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
    APP_MODE="debug"
fi

run_as_node() {
    HOME="${NODE_HOME}" su -p "${NODE_USER}" -c "${1}"
}

run_as_node "env > /tmp/.env"
run_as_node "node /rapydo/config-env.ts"
run_as_node "node /rapydo/merge.js"

if [ "$APP_MODE" == 'production' ]; then

	# --production to install only dependencies e not devDependencies
	run_as_node "yarn install"
	run_as_node "yarn run courtesy"
	run_as_node "yarn run build -- --base-href https://${BASE_HREF}${FRONTEND_PREFIX} --deleteOutputPath=false"
	run_as_node "yarn run gzip"

elif [ "$APP_MODE" == 'debug' ]; then

	run_as_node "yarn install"
	run_as_node "yarn start"

elif [ "$APP_MODE" == 'test' ]; then

	sleep infinity

else
	echo "Unknown APP_MODE: ${APP_MODE}"
fi
