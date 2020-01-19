# !/bin/bash
set -e

# Renewall script
echo "Mode: *$MODE*"
echo "Domain: $DOMAIN"

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

force=""
if [[ "$1" == "--force" ]]; then
        force="--force"
fi


if [[ "$DOMAIN" == "localhost" ]]; then
    # exactly as in docker-entrypoint.sh 
    echo "Creating a self signed SSL certificate"
    mkdir -p $CERTDIR/$CERTSUBDIR
    selfsign

    if [ "$?" == "0" ]; then
        echo "Self signed SSL certificate successfully created"

        cd ${CERTDIR}
        rm -f neo4j.cert neo4j.key
        ln -sfn ${CERTCHAINFILE} neo4j.cert
        ln -sfn ${CERTKEYFILE} neo4j.key
        chmod +r ${CERTCHAINFILE} ${CERTKEYFILE}
    else
        echo "Self signed SSL certificate generation failed!"
    fi

else
    ./acme.sh --issue ${force} --debug \
        --fullchain-file ${CERTCHAIN} --key-file ${CERTKEY} \
        -d $DOMAIN -w $WWWDIR $MODE

    if [ "$?" == "0" ]; then
        # List what we have
        echo "Completed. Check:"
        ./acme.sh --list

        # Could be executed with acme.sh by using --reloadcmd 'nginx -s reload'
        nginx -s reload

        cd ${CERTDIR}
        rm -f neo4j.cert neo4j.key
        ln -sfn ${CERTCHAINFILE} neo4j.cert
        ln -sfn ${CERTKEYFILE} neo4j.key
    else
        echo "ACME FAILED!"
    fi
fi
