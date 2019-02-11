#!/bin/bash
set -e


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
    echo "DHParam is missing, creating a new $DHPARAM"
    openssl dhparam -out $DHPARAM 2048 -dsaparam
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
