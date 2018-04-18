#!/bin/bash
set -e

######################################
#
# Entrypoint!
#
######################################

# Defaults
if [ -z APP_MODE ]; then
    APP_MODE="debug"
fi

# Move on build?
node /rapydo/utility/merge.js

# --production to install only dependencies e not devDependencies
npm --prefix $MODULE_PATH install

# npm cache clean

export PATH=$PATH:$MODULE_PATH/node_modules/.bin
export NODE_PATH=$MODULE_PATH/node_modules

# cd $MODULE_PATH
# cd /rapydo

# Only required for Angularjs ... remove me in a near future
cd $MODULE_PATH
rm -rf bootstrap3.zip bootstrap-3.3.7-dist
wget https://github.com/twbs/bootstrap/releases/download/v3.3.7/bootstrap-3.3.7-dist.zip -O bootstrap3.zip
unzip bootstrap3.zip
rm -rf bootstrap3.zip 
cd -

cd $NODE_PATH
ln -sf ../bootstrap-3.3.7-dist bootstrap3
cd -
# ######################################################## #


if [ "$APP_MODE" == 'production' ]; then

	exec npm run build 

elif [ "$APP_MODE" == 'debug' ]; then

	exec npm start 

fi
