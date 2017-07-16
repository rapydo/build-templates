#!/bin/bash
set -e

######################################
#
# Entrypoint!
#
######################################

# # check environment variables
if [ -z "$VANILLA_PACKAGE" -a -z "$IRODS_HOST" -a -z "ALCHEMY_HOST" ];
then
    echo "Cannot launch API server without base environment variables"
    echo "Please review your '.env' file"
    exit 1
fi

# Defaults
if [ -z APP_MODE ]; then
    APP_MODE="debug"
fi
APIUSERID=$(id -u $APIUSER)
chown $APIUSERID $CODE_DIR

# IF INIT is necessary
secret_file="$JWT_APP_SECRETS/secret.key"
if [ ! -f "$secret_file" ]; then
    echo "First time access"

    # Create the secret to enable security on JWT tokens
    mkdir -p $JWT_APP_SECRETS
    head -c 24 /dev/urandom > $secret_file
    chown -R $APIUSERID $JWT_APP_SECRETS $UPLOAD_PATH

    # certificates for external oauth services (e.g. B2ACCESS)
    update-ca-certificates

    # FIXME: use our python code to wait for all services to be up?
    echo "WARNING: currently skipping automatic initialization"
    # echo "Init flask app"
    # restapi init --sleep
    # if [ "$?" == "0" ]; then
    #     echo
    # else
    #     echo "Failed to startup flask!"
    #     exit 1
    # fi

fi

#####################
# Sync after init with compose call from outside
touch /${JWT_APP_SECRETS}/initialized

#####################
# Extra scripts
dedir="/docker-entrypoint.d"
for f in `ls $dedir`; do
    case "$f" in
        *.sh)     echo "running $f"; bash "$dedir/$f" ;;
        *)        echo "ignoring $f" ;;
    esac
    echo
done

#####################
# Completed

if [ "$1" != 'rest' ]; then
    ## CUSTOM COMMAND
    echo "Requested custom command:"
    echo "\$ $@"
    $@
    exit 0
else
    ## NORMAL MODES

    # FIXME: check again, when the vanilla directory seems to evanish
    export PYTHONPATH=$CODE_DIR

    echo "REST API backend server is ready to be launched"

    if [ "$APP_MODE" == 'production' ]; then

        echo "launching uwsgi"

        # TODO: check after init phase was implemented
        # Fix to avoid: unable to load app 0 (mountpoint='')
        # (callable not found or import error)
        sleep 25

        myuwsgi
    elif [ "$APP_MODE" == 'development' ]; then
        echo "launching flask"
        rapydo
    else
        echo "Debug mode"
        # sleep infinity
    fi

    exec pysleeper
    exit 0
fi
