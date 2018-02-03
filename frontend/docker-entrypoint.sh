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

# npm --prefix $MODULE_PATH install --no-bin-links
# why no-bin-links? MODULE_PATH is mounted from the host machine and this can
# modify how sym-links can be followed leading to problems at runtime,
# for example: throw new Error('"' + aSource + '" is not in the SourceMap.');
# during the build

# npm cache clean

export PATH=$PATH:$MODULE_PATH/node_modules/.bin
export NODE_PATH=$MODULE_PATH/node_modules

# cd $MODULE_PATH
# cd /rapydo

exec npm start 
