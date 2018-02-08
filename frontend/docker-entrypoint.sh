#!/bin/bash
set -e

######################################
#
# Entrypoint!
#
######################################

# Move on build?
node /rapydo/utility/merge.js

# --production to install only dependencies e not devDependencies
npm --prefix $MODULE_PATH install

#npm cache clean

export PATH=$PATH:$MODULE_PATH/node_modules/.bin
export NODE_PATH=$MODULE_PATH/node_modules

# cd $MODULE_PATH
# cd /rapydo

exec npm start 
