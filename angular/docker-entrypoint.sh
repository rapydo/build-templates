#!/bin/bash
set -e

#######################################
#                                     #
#             Entrypoint!             #
#                                     #
#######################################

if [[ ! -t 0 ]]; then
    /bin/bash /etc/banner.sh
fi

NODE_USER="node"
NODE_HOME=$(eval echo ~$NODE_USER)

DEVID=$(id -u "$NODE_USER")
if [ "$DEVID" != "$CURRENT_UID" ]; then
    echo "Fixing uid of user ${NODE_USER} from $DEVID to $CURRENT_UID..."
    usermod -u "$CURRENT_UID" "$NODE_USER"
fi

GROUPID=$(id -g $NODE_USER)
if [ "$GROUPID" != "$CURRENT_GID" ]; then
    echo "Fixing gid of user $NODE_USER from $GROUPID to $CURRENT_GID..."
    groupmod -og "$CURRENT_GID" "$NODE_USER"
fi


echo "Running as ${NODE_USER} (uid $(id -u ${NODE_USER}))"

# Defaults
if [ -z APP_MODE ]; then
    APP_MODE="development"
fi

run_as_node() {
    HOME="${NODE_HOME}" su -p "${NODE_USER}" -c "${1}"
}

if [ "$APP_MODE" == "test" ]; then
    export BACKEND_HOST=${CYPRESS_BACKEND_HOST}
fi

run_as_node "env > /tmp/.env"
run_as_node "node /rapydo/config-env.ts"
run_as_node "node /rapydo/merge.js"

if [ "$APP_MODE" == "production" ]; then

    run_as_node "yarn install --production"
    run_as_node "npx browserslist@latest --update-db"
    run_as_node "reload-types"
    if [ "$ENABLE_ANGULAR_SSR" == "0" ]; then
        run_as_node "yarn run build"
    else
        if [[ -z $FRONTEND_URL ]];
        then
            FRONTEND_URL="https://${BASE_HREF}${FRONTEND_PREFIX}"
        elif [[ $FRONTEND_URL != */ ]];
        then
            FRONTEND_URL="${FRONTEND_URL}/"
        fi
        run_as_node "yarn run build:ssr"
        run_as_node "sitemap-generator --last-mod --change-freq monthly --priority-map '1.0,0.8,0.6,0.4,0.2' --max-depth 12 --verbose --filepath /app/dist/sitemap.xml ${FRONTEND_URL}"
        run_as_node "echo \"Sitemap: ${FRONTEND_URL}sitemap.xml\" > /app/dist/robots.txt"
        run_as_node "echo \"User-agent:*\" >> /app/dist/robots.txt"
        run_as_node "echo \"Allow: /\" >> /app/dist/robots.txt"
        run_as_node "echo \"Disallow:\" >> /app/dist/robots.txt"
    fi
    run_as_node "yarn run gzip"
    run_as_node "yarn run move-build-online"

elif [ "$APP_MODE" == "development" ]; then

    # Do not install dev dependencies (only needed for tests)
    run_as_node "yarn install --production"
    run_as_node "reload-types"
    run_as_node "yarn start"

elif [ "$APP_MODE" == "test" ]; then

    sleep infinity

else
    echo "Unknown APP_MODE: ${APP_MODE}"
fi
