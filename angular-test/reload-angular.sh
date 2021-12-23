#!/bin/bash

NODE_USER="node"
NODE_HOME=$(eval echo ~$NODE_USER)

run_as_node() {
    HOME="${NODE_HOME}" su -p "${NODE_USER}" -c "${1}"
}

if [ "$APP_MODE" == "production" ]; then
    echo "Reload is not required in production mode"

elif [ "$APP_MODE" == "development" ]; then

    run_as_node "node /rapydo/merge.js"
    run_as_node "yarn workspaces focus --all"
    run_as_node "reload-types"
    echo "Reloading Angular..."
    # run_as_node "yarn start" 
    touch /app/app/rapydo/main.ts
elif [ "$APP_MODE" == "test" ]; then
    echo "Reload is not required in test mode"
fi
