#!/bin/bash
set -e

######################################
# Entrypoint!
######################################

# Defaults
if [ -z APP_MODE ]; then
    APP_MODE="debug"
fi

# Install node modules
if [ -d "node_modules" ]; then
    echo "Already built"
else
    echo "Building"
    yarn install
fi

# What else?
if [ -d "node_modules" ]; then
if [ "$APP_MODE" == 'production' ]; then
  echo "Prod mode: build and serve"
  exec yarn build && cd build && python3 -m http.server 5000
else
# elif [ "$APP_MODE" == 'debug' ]; then
  echo "Dev mode: sleeping"
  exec sleep 1234567890
fi
