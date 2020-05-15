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

chown -R "$NODE_USER" /app

# Defaults
if [ -z APP_MODE ]; then
    APP_MODE="debug"
fi

HOME="$NODE_HOME" su -p "$NODE_USER" -c 'env > /tmp/.env'
HOME="$NODE_HOME" su -p "$NODE_USER" -c 'node /rapydo/config-env.ts'

HOME="$NODE_HOME" su -p "$NODE_USER" -c 'node /rapydo/merge.js'

# --production to install only dependencies e not devDependencies
HOME="NODE_HOME" su -p "$NODE_USER" -c 'yarn install'

if [ "$APP_MODE" == 'production' ]; then

	HOME="$NODE_HOME" su -p "$NODE_USER" -c 'yarn run courtesy'
	HOME="$NODE_HOME" su -p "$NODE_USER" -c 'yarn run build -- --base-href https://${BASE_HREF}${FRONTEND_PREFIX} --deleteOutputPath=false'
	HOME="$NODE_HOM"E su -p "$NODE_USER" -c 'yarn run gzip'

elif [ "$APP_MODE" == 'debug' ]; then

	HOME="$NODE_HOME" su -p "$NODE_USER" -c 'yarn start'

elif [ "$APP_MODE" == 'test' ]; then

	HOME="$NODE_HOME" su -p "$NODE_USER" -c 'yarn run single-test'

elif [ "$APP_MODE" == 'cypress' ]; then

	HOME="$NODE_HOME" su -p "$NODE_USER" -c 'yarn run start-cypress'

else
	echo "Unknown APP_MODE: [${APP_MODE}]"
fi
