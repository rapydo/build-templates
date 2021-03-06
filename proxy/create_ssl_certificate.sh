# !/bin/bash
set -e

hostname=$1

if [[ "$hostname" == "localhost" ]]; then

    echo "Creating a self signed SSL certificate"
    mkdir -p ${CERTDIR}/${CERTSUBDIR}

    openssl req -x509 -nodes -days 365 -newkey rsa:4096 -keyout $CERTKEY -out $CERTCHAIN -subj '/CN=localhost'

    if [ "$?" == "0" ]; then
        echo "Self signed SSL certificate successfully created"

        # This is required to let other services to read the certificates
        chmod +r ${CERTCHAIN} ${CERTKEY}
    else
        echo "Self signed SSL certificate generation failed!"
    fi

else

    if [[ "$hostname" != "$DOMAIN" ]]; then
        echo ""
        echo "Domain mismatch: you requested **${hostname}** but your proxy is configured with **${DOMAIN}**"
        echo ""
        echo "Please re-created the proxy container with the correct configuration"
        echo ""
        exit 1
    fi

    echo "Domain: $DOMAIN"
    echo "Domain Aliases: $DOMAIN_ALIASES"
    echo "SMTP Admin: $SMTP_ADMIN"

    if [ -z "$SMTP_ADMIN" ]; then
        echo "SMTP_ADMIN is not set, can't continue"
        exit 1
    fi

    NGINX_PID="/var/run/nginx.pid"

    echo "Requesting new SSL certificate to Let's Encrypt"

    domains="-d $DOMAIN"
    for d in ${DOMAIN_ALIASES/,/ }; do
        domains="${domains} -d ${d}"
    done

    if [[ -e ${NGINX_PID} ]]; then
        certbot certonly --debug --non-interactive ${domains} \
            -a webroot -w ${WWWDIR} \
            --agree-tos --email ${SMTP_ADMIN}
    else
        certbot certonly --debug --non-interactive ${domains} \
            --standalone \
            --agree-tos --email ${SMTP_ADMIN}
    fi

    if [ "$?" == "0" ]; then
        # List what we have
        echo "Completed. Check:"
        certbot certificates

        mkdir -p ${CERTDIR}/${CERTSUBDIR}
        cp /etc/letsencrypt/archive/${DOMAIN}/fullchain1.pem ${CERTCHAIN}
        cp /etc/letsencrypt/archive/${DOMAIN}/privkey1.pem ${CERTKEY}

        # This is required to let other services to read the certificates
        chmod +r ${CERTCHAIN} ${CERTKEY}

        if [[ -e ${NGINX_PID} ]]; then
            nginx -s reload;
        fi

    else
        echo "SSL issuing FAILED!"
    fi
fi
