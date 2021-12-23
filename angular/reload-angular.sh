#!/bin/bash

NODE_USER="node"
NODE_HOME=$(eval echo ~$NODE_USER)

run_as_node() {
    HOME="${NODE_HOME}" su -p "${NODE_USER}" -c "${1}"
}

if [ "$APP_MODE" == "production" ]; then
    echo "Reload is not required in production mode"

elif [ "$APP_MODE" == "development" ]; then

    run_as_node "cp /app/package.json /tmp/package.json.bak"
    run_as_node "node /rapydo/merge.js"

    if ! cmp -s /app/package.json /tmp/package.json.bak;
    then
        echo "Package.json changed:"
        diff --color <(cat /tmp/package.json.bak | sed "s/,/\n/g") <(cat package.json | sed "s/,/\n/g")
        # Do not install dev dependencies (only needed for tests)
        # run_as_node "yarn install --production"
        run_as_node "yarn workspaces focus --production"
    fi
    run_as_node "reload-types"
    echo "Reloading Angular..."
    # run_as_node "yarn start" 
    touch /app/app/rapydo/main.ts
elif [ "$APP_MODE" == "test" ]; then
    echo "Reload is not required in test mode"
fi
