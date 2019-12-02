#!/bin/bash
set -e

#######################################
#                                     #
#             Entrypoint!             #
#                                     #
#######################################

NODE_USER="node"
NODE_HOME=$(eval echo ~$NODE_USER)

DEVID=$(id -u ${NODE_USER})
if [ "$DEVID" != "$CURRENT_UID" ]; then
    echo "Fixing user ${NODE_USER} uid from $DEVID to $CURRENT_UID..."
    usermod -u $CURRENT_UID ${NODE_USER}
fi

GROUPID=$(id -g $NODE_USER)
if [ "$GROUPID" != "$CURRENT_GID" ]; then
    echo "Fixing user $NODE_USER gid from $GROUPID to $CURRENT_GID..."
    groupmod -g $CURRENT_GID $NODE_USER
fi


echo "Running as ${NODE_USER} (uid $(id -u ${NODE_USER}))"

chown -R ${NODE_USER} /app

# Defaults
if [ -z APP_MODE ]; then
    APP_MODE="debug"
fi

#su -p ${NODE_USER} -c 'mycommand'
HOME=$NODE_HOME su -p ${NODE_USER} -c 'env > /tmp/.env'
HOME=$NODE_HOME su -p ${NODE_USER} -c 'node /rapydo/config-env.ts'

HOME=$NODE_HOME su -p ${NODE_USER} -c 'node /rapydo/merge.js'

# --production to install only dependencies e not devDependencies
HOME=$NODE_HOME su -p ${NODE_USER} -c 'npm install'

if [ "$APP_MODE" == 'production' ]; then

	HOME=$NODE_HOME su -p ${NODE_USER} -c 'npm run build'

elif [ "$APP_MODE" == 'debug' ]; then

	HOME=$NODE_HOME su -p ${NODE_USER} -c 'npm start'

elif [ "$APP_MODE" == 'test' ]; then

	HOME=$NODE_HOME su -p ${NODE_USER} -c 'npm run single-test'

elif [ "$APP_MODE" == 'cypress' ]; then

	HOME=$NODE_HOME su -p ${NODE_USER} -c 'npm run start-cypress'

else
	echo "Unknown APP_MODE: [${APP_MODE}]"
fi
