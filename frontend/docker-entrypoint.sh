#!/bin/bash
set -e

######################################
#
# Entrypoint!
#
######################################

cd $MODULE_PATH

ln -sfn /app/frontend/package.json

cd - 

npm --prefix $MODULE_PATH install

export NODE_PATH=$MODULE_PATH/node_modules

exec npm start 
