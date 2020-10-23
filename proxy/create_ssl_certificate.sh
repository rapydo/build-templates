# !/bin/bash
set -e

# Renewall script

hostname=""
force=""
if [[ "$1" == "--force" ]]; then
    force="--force"
    hostname=$2
else
    hostname=$1
fi

if [[ "$hostname" != "$DOMAIN" ]]; then
    echo "Domain mismatch: you requested **${hostname}** but your proxy is configured with **${DOMAIN}**"
    echo ""
    echo "Please re-created the proxy container with the correct configuration"
    echo ""
    exit 1
fi

echo "Mode: *$MODE*"
echo "Domain: $DOMAIN"


if [[ "$DOMAIN" == "localhost" ]]; then

    echo "Creating a self signed SSL certificate"
    mkdir -p ${CERTDIR}/${CERTSUBDIR}

    openssl req -x509 -nodes -days 365 -newkey rsa:4096 -keyout $CERTKEY -out $CERTCHAIN -subj '/CN=localhost'

    if [ "$?" == "0" ]; then
        echo "Self signed SSL certificate successfully created"

        # It is still required?
        chmod +r ${CERTCHAIN} ${CERTKEY}
    else
        echo "Self signed SSL certificate generation failed!"
    fi

else

    if [ "$SMTP_ADMIN" != "" ]; then
        echo "Reference email: $SMTP_ADMIN"
        ./acme.sh --update-account  --accountemail $SMTP_ADMIN
        if [ "$?" == "0" ]; then
            # List what we have
            echo "Email account updated"
        else
            echo "SMTP problem"
            exit 1
        fi
    fi

    echo "Requesting new SSL certificate to letsencrypt"

    ./acme.sh --issue ${force} --debug \
        --fullchain-file ${CERTCHAIN} --key-file ${CERTKEY} \
        -d $DOMAIN -w $WWWDIR $MODE

    if [ "$?" == "0" ]; then
        # List what we have
        echo "Completed. Check:"
        ./acme.sh --list

        # It is still required?
        chmod +r ${CERTCHAIN} ${CERTKEY}

        # Could be executed with acme.sh by using --reloadcmd 'nginx -s reload'
        nginx -s reload
    else
        echo "ACME FAILED!"
    fi
fi
