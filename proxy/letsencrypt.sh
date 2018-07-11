# !/bin/bash
set -e

# DOMAIN="b2stage-test.cineca.it"
# MODE="--staging"
# MODE=""

# Renewall script
echo "Mode: *$MODE*"
echo "Domain: $DOMAIN"

# TODO: test if it works
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

./acme.sh --issue --debug \
    --fullchain-file ${CERTCHAIN} --key-file ${CERTKEY} \
    -d $DOMAIN -w $WWWDIR $MODE

if [ "$?" == "0" ]; then
    # List what we have
    echo "Completed. Check:"
    ./acme.sh --list

    nginx -s reload

    cd ${CERTDIR}
    rm -f neo4j.cert neo4j.key
    ln -sfn ${CERTCHAINFILE} neo4j.cert
    ln -sfn ${CERTKEYFILE} neo4j.key
else
    echo "ACME FAILED!"
fi
