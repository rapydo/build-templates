#!/bin/bash
set -e

DEVID=$(id -u $APIUSER)
if [ "$DEVID" != "$CURRENT_UID" ]; then
    echo "Fixing uid of user $APIUSER from $DEVID to $CURRENT_UID..."
    usermod -u $CURRENT_UID $APIUSER
fi

GROUPID=$(id -g $APIUSER)
if [ "$GROUPID" != "$CURRENT_GID" ]; then
    echo "Fixing gid user $APIUSER from $GROUPID to $CURRENT_GID..."
    groupmod -og $CURRENT_GID $APIUSER
fi

# Defaults
if [ -z APP_MODE ]; then
    APP_MODE="development"
fi

# INIT if necessary
secret_file="$JWT_APP_SECRETS/secret.key"
init_file="${JWT_APP_SECRETS}/initialized"

if [ ! -f "$secret_file" ]; then

    # Create the secret to enable security on JWT tokens
    mkdir -p $JWT_APP_SECRETS
    head -c 24 /dev/urandom > $secret_file

    # certificates chains for external oauth services (e.g. B2ACCESS)
    update-ca-certificates
fi

if [ ! -f "$init_file" ]; then
    echo "Init flask app"
    HOME=$CODE_DIR su -p $APIUSER -c 'restapi init --wait'
    if [ "$?" == "0" ]; then
        # Sync after init with compose call from outside
        touch $init_file
    else
        echo "Failed to startup flask!"
        exit 1
    fi
fi

# fix permissions on the main development folder
chown $APIUSER $CODE_DIR

#####################
# Extra scripts
# dedir="/docker-entrypoint.d"
# for f in $(ls $dedir); do
#     case "$f" in
#         *.sh)     echo "running $f"; bash "$dedir/$f" ;;
#         *)        echo "ignoring $f" ;;
#     esac
#     echo
# done

#####################
# Fixers: part 1

if [ -d "$CERTDIR" ]; then
    chown -R $APIUSER $CERTDIR
fi

#####################

export CONTAINER_ID=$(head -1 /proc/self/cgroup|cut -d/ -f3 | cut -c1-12)
export IS_CELERY_CONTAINER=0

if [[ "$CRONTAB_ENABLE" == "1" ]]; then
    if [[ "$(find /etc/cron.rapydo/ -name '*.cron')" ]]; then
        echo "Enabling cron..."

        # sed is needed to add quotes to env values
        env | sed 's/=\(.*\)/="\1"/' > /etc/rapydo-environment

        touch /var/log/cron.log
        chown $APIUSER /var/log/cron.log
        # Adding an empty line to cron log
        echo "" >> /var/log/cron.log
        cron
        # .cron extension is to avoid accidentally including backup files from editors
        cat /etc/cron.rapydo/*.cron | crontab -u ${APIUSER} -
        crontab -u ${APIUSER} -l
        echo "Cron enabled"
        # -n 1 will only print the empty line previously added
        tail -n 1 -f /var/log/cron.log &
    else
        echo "Found no cronjob to be enabled, skipping crontab setup"
    fi
fi

# Completed

if [ "$1" != 'rest' ]; then
    ## CUSTOM COMMAND
    echo "Requested custom command:"
    echo "\$ $@"
    $@
else
    ## NORMAL MODES
    echo "REST API backend server is ready to be launched"

    if [ "$APP_MODE" == 'production' ]; then

        echo "waiting for services"
        HOME=$CODE_DIR su -p $APIUSER -c 'restapi wait'

        echo "ready to launch production gunicorn+meinheld"
        mygunicorn

    else
        # HOME=$CODE_DIR su -p $APIUSER -c 'restapi launch'
        echo "Development mode"
    fi

    sleep infinity
fi
