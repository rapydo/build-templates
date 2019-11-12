#!/bin/bash
set -e

CONF_DIR="/etc/nginx/sites-enabled"
TEMPLATE_DIR="/etc/nginx/sites-enabled-templates"

mkdir -p ${CONF_DIR}

CONF_TEMPLATE="${TEMPLATE_DIR}/production"
HEADERS_TEMPLATE="${TEMPLATE_DIR}/production-headers"

CONF_FILE="${CONF_DIR}/production"
HEADERS_FILE="${CONF_DIR}/production-headers"

if [[ -f "$CONF_TEMPLATE" ]]; then
    echo "Converting ${CONF_TEMPLATE} into ${CONF_FILE} by replacing env"
    # We pass to envsubst the list of env variables, to only replace existing variables
    envsubst "$(env | cut -d= -f1 | sed -e 's/^/$/')" < $CONF_TEMPLATE > $CONF_FILE
else
    echo "${CONF_TEMPLATE} not found"
fi

if [[ -f "$HEADERS_TEMPLATE" ]]; then
    echo "Converting ${HEADERS_TEMPLATE} into ${HEADERS_FILE} by replacing env"
    # We pass to envsubst the list of env variables, to only replace existing variables
    envsubst "$(env | cut -d= -f1 | sed -e 's/^/$/')"< $HEADERS_TEMPLATE > $HEADERS_FILE
else
    echo "${HEADERS_TEMPLATE} not found"
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
    if [ "$DOMAIN" == "localhost" ]; then

        if [ ! -f "$CERTCHAIN" ]; then
            echo "Creating a self signed SSL certificate"
            mkdir -p $CERTDIR/$CERTSUBDIR
            selfsign
        else
            echo "A SSL certificate already exist, cannot create new self signed"
        fi
    else
        echo "Requesting new SSL certificate to letsencrypt"

        /bin/bash $@
    fi
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
        selfsign
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
