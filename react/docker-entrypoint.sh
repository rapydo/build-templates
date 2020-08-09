#!/bin/bash
set -e

# Defaults
if [ -z APP_MODE ]; then
    APP_MODE="development"
fi

# Install node modules
if [ -d "node_modules" ]; then
    echo "Already built"
else
    echo "Building"
    yarn install
fi

# What else?
if [ "$APP_MODE" == 'production' ]; then
  echo "Remote mode: build"
  exec yarn build
elif [ "$APP_MODE" == 'development' ]; then
  # exec yarn build && cd build && python3 -m http.server 5000
  echo "Development mode: sleeping"
  exec sleep 1234567890
else
  echo "Unknown mode: *$APP_MODE*"
fi
