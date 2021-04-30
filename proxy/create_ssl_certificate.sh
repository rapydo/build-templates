# !/bin/bash
set -e

hostname=$1

if [[ "$hostname" != "$DOMAIN" ]]; then
    echo "Domain mismatch: you requested **${hostname}** but your proxy is configured with **${DOMAIN}**"
    echo ""
    echo "Please re-created the proxy container with the correct configuration"
    echo ""
    exit 1
fi

echo "Domain: $DOMAIN"
echo "Domain Aliases: $DOMAIN_ALIASES"


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

    # if [ "$SMTP_ADMIN" != "" ]; then
    #     echo "Reference email: $SMTP_ADMIN"
    #     ./acme.sh --update-account  --accountemail $SMTP_ADMIN
    #     if [ "$?" == "0" ]; then
    #         # List what we have
    #         echo "Email account updated"
    #     else
    #         echo "SMTP problem"
    #         exit 1
    #     fi
    # fi

    echo "Requesting new SSL certificate to letsencrypt"

    domains="-d $DOMAIN"
    # Add additional -d for each alias
    # Before: not tested
    for d in ${DOMAIN_ALIASES/,/ }; do
        domains="${domains} -d ${d}"
    done

    # ./acme.sh --issue --debug \
    #     --fullchain-file ${CERTCHAIN} --key-file ${CERTKEY} \
    #     ${domains} -w ${WWWDIR}

    certbot certonly --debug --non-interactive ${domains} \
        -a webroot -w ${WWWDIR} \
        --agree-tos --email ${SMTP_ADMIN}

    if [ "$?" == "0" ]; then
        # List what we have
        echo "Completed. Check:"
        # ./acme.sh --list
        certbot certificates

        # It is still required?
        # chmod +r ${CERTCHAIN} ${CERTKEY}

        mkdir -p ${CERTDIR}/${CERTSUBDIR}
        cp /etc/letsencrypt/archive/${DOMAIN}/fullchain1.pem ${CERTCHAIN}
        cp /etc/letsencrypt/archive/${DOMAIN}/privkey.pem ${CERTKEY}

        nginx -s reload
    else
        echo "SSL issuing FAILED!"
    fi
fi
