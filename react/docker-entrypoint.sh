#!/bin/bash
set -e

######################################
#
# Entrypoint!
#
######################################

# # Defaults
# if [ -z APP_MODE ]; then
#     APP_MODE="debug"
# fi

# # Move on build?
# node /rapydo/utility/merge.js
# # --production to install only dependencies e not devDependencies
# npm --prefix $MODULE_PATH install
# # npm cache clean

# export PATH=$PATH:$MODULE_PATH/node_modules/.bin
# export NODE_PATH=$MODULE_PATH/node_modules

# if [ "$APP_MODE" == 'production' ]; then
# 	exec npm run build
# elif [ "$APP_MODE" == 'debug' ]; then
# 	exec npm start
# fi


if [ -d "node_modules" ]; then
    echo "Already built"
else
    echo "Building"
    yarn install
fi

echo
echo "Completed!"
sleep 1234567890
