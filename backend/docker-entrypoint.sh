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

# IF INIT is necessary
secret_file="$JWT_APP_SECRETS/secret.key"
check_volumes=$([ "$(ls -A $CODE_DIR)" ] && echo "yes" || echo "no")

if [ ! -f "$secret_file" ]; then
    if [ "$check_volumes" == 'yes' ]; then
        echo "First time access"

        # Create the secret to enable security on JWT tokens
        mkdir -p $JWT_APP_SECRETS
        head -c 24 /dev/urandom > $secret_file
        chown -R $APIUSER $JWT_APP_SECRETS $UPLOAD_PATH

        # certificates chains for external oauth services (e.g. B2ACCESS)

        update-ca-certificates

        echo "Init flask app"
        eval "$DEV_SU -c 'restapi init --wait'"
        if [ "$?" == "0" ]; then
            echo
        else
            echo "Failed to startup flask!"
            exit 1
        fi
    fi
else
    #####################
    # Sync after init with compose call from outside
    if [ "$check_volumes" == 'yes' ]; then
        touch /${JWT_APP_SECRETS}/initialized
    fi
fi

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
# Fixers: part 1

# FIXME: execute fixers on all mounted dirs?
# can we get this info from df or similar?
if [ -d "$CODE_DIR" ]; then
    # TODO: evaluate if this should be executed before init
    chown -R $APIUSER $CODE_DIR
fi
if [ -d "$CERTDIR" ]; then
    chown -R $APIUSER $CERTDIR
fi
UPLOAD_DIR="/uploads"
if [ -d "$UPLOAD_DIR" ]; then
    chown -R $APIUSER $UPLOAD_DIR
fi

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
    echo "REST API backend server is ready to be launched"

    if [ "$APP_MODE" == 'production' ]; then

        ############################
        # TODO: to be tested, at least in DEBUG mode
        echo "waiting for services"
        eval "$DEV_SU -c 'restapi wait'"
        ############################
        echo "ready to launch production proxy+wsgi"

        myuwsgi

    elif [ "$APP_MODE" == 'development' ]; then

        echo "launching flask"
        eval "$DEV_SU -c 'restapi launch'"

    else
        echo "Debug mode"
    fi

    exec pysleeper
    exit 0
fi
