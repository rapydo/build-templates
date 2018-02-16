# !/bin/bash
set -e

# DOMAIN="b2stage-test.cineca.it"
# MODE="--staging"
# MODE=""

# Renewall script
echo "Mode: *$MODE*"
echo "Domain: $DOMAIN"

if [ "$SMTP_ADMIN" != "" ]; then
    echo "Reference email: $SMTP_ADMIN"
    ./acme.sh --update-account  --accountemail $SMTP_ADMIN
fi

./acme.sh --issue --debug \
    --fullchain-file ${CERTCHAIN} --key-file ${CERTKEY} \
    -d $DOMAIN -w $WWWDIR $MODE

if [ "$?" == "0" ]; then
    # List what we have
    echo "Completed. Check:"
    ./acme.sh --list

    nginx -s reload
else
    echo "ACME FAILED!"
fi
