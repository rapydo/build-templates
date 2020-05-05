#!/bin/bash
set -e

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
eval CSP_SCRIPT_SRC=$CSP_SCRIPT_SRC
eval CSP_IMG_SRC=$CSP_IMG_SRC
# *.conf are loaded from main nginx.conf
# *.service are loaded from production.conf
# confs with no extension are loaded from service conf

convert_conf ${TEMPLATE_DIR}/production.conf ${CONF_DIR}/production.conf
convert_conf ${TEMPLATE_DIR}/service_confs/backend.conf ${CONF_DIR}/backend.service

# Frontend configuration
if [[ -f "$TEMPLATE_DIR/service_confs/${FRONTEND}.conf" ]]; then
    convert_conf ${TEMPLATE_DIR}/service_confs/${FRONTEND}.conf ${CONF_DIR}/${FRONTEND}.service
fi

# Custom Frontend header configuration, if any
if [[ -f "$TEMPLATE_DIR/headers_confs/production-${FRONTEND}-headers.conf" ]]; then
    convert_conf ${TEMPLATE_DIR}/headers_confs/production-${FRONTEND}-headers.conf ${CONF_DIR}/production-headers
else
    convert_conf ${TEMPLATE_DIR}/headers_confs/production-headers.conf ${CONF_DIR}/production-headers
fi

# Extra services....
# Not implemented

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

######################################
#
# Entrypoint!
#
######################################

# IF INIT is necessary
if [ "$DOMAIN" != "" ]; then
    echo "Production mode"

    if [ ! -f "$CERTCHAIN" ]; then
        echo "First time access"
        /bin/bash updatecertificates
    fi
fi

if [ ! -f "$DHPARAM" ]; then
    echo "DHParam is missing, creating a new $DHPARAM with length = ${DEFAULT_DHLEN}"
    openssl dhparam -out $DHPARAM $DEFAULT_DHLEN -dsaparam
fi

#####################
# Extra scripts
dedir="/docker-entrypoint.d"
for f in $(ls $dedir); do
    case "$f" in
        *.sh)     echo "running $f"; bash "$dedir/$f" ;;
        *)        echo "ignoring $f" ;;
    esac
    echo
done

# Let other services, like neo4j, to write into this volume
chmod -R +w /etc/letsencrypt
chmod +x /etc/letsencrypt

#####################
# Completed
echo "launching server"
exec nginx -g 'daemon off;'
