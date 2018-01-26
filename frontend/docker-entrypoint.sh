#!/bin/bash
set -e

######################################
#
# Entrypoint!
#
######################################

node /rapydo/merge.js

npm --prefix $MODULE_PATH install

export NODE_PATH=$MODULE_PATH/node_modules

cd $MODULE_PATH

exec npm start 
