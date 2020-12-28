#!/bin/bash
set -e

PROXY_USER="nginx"

DEVID=$(id -u "$PROXY_USER")
if [ "$DEVID" != "$CURRENT_UID" ]; then
    echo "Fixing uid of user ${PROXY_USER} from $DEVID to $CURRENT_UID..."
    usermod -u "$CURRENT_UID" "$PROXY_USER"
fi

GROUPID=$(id -g $PROXY_USER)
if [ "$GROUPID" != "$CURRENT_GID" ]; then
    echo "Fixing gid of user $PROXY_USER from $GROUPID to $CURRENT_GID..."
    groupmod -og "$CURRENT_GID" "$PROXY_USER"
fi

echo "Running as ${PROXY_USER} (uid $(id -u ${PROXY_USER}))"

CONF_DIR="/etc/nginx/sites-enabled"
TEMPLATE_DIR="/etc/nginx/sites-enabled-templates"

mkdir -p ${CONF_DIR}

function convert_conf {
    CONF_TEMPLATE=$1
    CONF_FILE=$2
    if [[ -f "$CONF_TEMPLATE" ]]; then
        echo "Converting ${CONF_TEMPLATE} into ${CONF_FILE} by replacing env"
        # We pass to envsubst the list of env variables, to only replace existing variables
        envsubst "$(env | cut -d= -f1 | sed -e 's/^/$/')" < $CONF_TEMPLATE > $CONF_FILE
    else
        echo "${CONF_TEMPLATE} not found"
    fi

}

# remove single quotes from these variables to avoid nginx conf to be disrupted
export CSP_SCRIPT_SRC=${CSP_SCRIPT_SRC//\'/}
export CSP_IMG_SRC=${CSP_IMG_SRC//\'/}
export CSP_FONT_SRC=${CSP_FONT_SRC//\'/}
# add single quotes if non empty
# this command also works if the string is already single quoted
if [[ ! -z "$UNSAFE_EVAL" ]]; then
    export UNSAFE_EVAL="'${UNSAFE_EVAL//\'/}'"
fi
if [[ ! -z "$STYLE_UNSAFE_INLINE" ]]; then
    export STYLE_UNSAFE_INLINE="'${STYLE_UNSAFE_INLINE//\'/}'"
fi

if [[ -z "${CORS_ALLOWED_ORIGIN}" ]]; then
    export CORS_ALLOWED_ORIGIN=$DOMAIN;
fi
# *.conf are loaded from main nginx.conf
# *.service are loaded from ${APP_MODE}.conf
# confs with no extension are loaded from service conf

convert_conf ${TEMPLATE_DIR}/${APP_MODE}.conf ${CONF_DIR}/${APP_MODE}.conf
convert_conf ${TEMPLATE_DIR}/service_confs/backend.conf ${CONF_DIR}/backend.service

# Frontend configuration
if [[ -f "$TEMPLATE_DIR/service_confs/${FRONTEND}.conf" ]]; then
    if [[ -f "$TEMPLATE_DIR/service_confs/${FRONTEND}-${APP_MODE}.conf" ]]; then
        convert_conf ${TEMPLATE_DIR}/service_confs/${FRONTEND}-${APP_MODE}.conf ${CONF_DIR}/${FRONTEND}.service
    else
        convert_conf ${TEMPLATE_DIR}/service_confs/${FRONTEND}.conf ${CONF_DIR}/${FRONTEND}.service
    fi
fi

convert_conf ${TEMPLATE_DIR}/headers_confs/security-headers.conf ${CONF_DIR}/security-headers

# Extra services....
# Not implemented

if [ ! -f "$DHPARAM" ]; then
    echo "DHParam is missing, creating a new $DHPARAM with length = ${DEFAULT_DHLEN}"
    openssl dhparam -out $DHPARAM $DEFAULT_DHLEN -dsaparam
fi

if [ "$1" == 'updatecertificates' ]; then
    if pgrep "nginx" > /dev/null
        then
            echo "nginx is already running"
        else 
            echo "Starting nginx..."
            exec nginx -g 'daemon off;' &
    fi

    echo "Creating SSL certificate for domain: ${DOMAIN}"
    /bin/bash $@
    exit 0
fi

if [ "$1" != 'proxy' ]; then
    echo "Requested custom command:"
    echo "\$ $@"
    $@
    exit 0
fi

# IF INIT is necessary
if [ "$DOMAIN" != "" ]; then
    echo "Starting in ${APP_MODE} mode"

    if [ ! -f "$CERTCHAIN" ]; then
        echo "First time access"
        /bin/bash updatecertificates $DOMAIN
    fi
fi

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

# Let other services, like neo4j, to write into this volume
chmod -R +w /etc/letsencrypt
chmod +x /etc/letsencrypt

#####################
# Completed
echo "Executing nginx server, ready to accept connections"
exec nginx -g 'daemon off;'
