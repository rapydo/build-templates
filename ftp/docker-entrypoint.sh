#!/bin/bash
set -e

if [[ ! -t 0 ]]; then
    /bin/bash /etc/banner.sh
fi

CERT_FILE="/etc/letsencrypt/real/fullchain1.pem"
KEY_FILE="/etc/letsencrypt/real/privkey1.pem"

if [[ -f ${CERT_FILE} ]] && [[ -f ${KEY_FILE} ]]; then
    echo "Enabling SSL"
    cat ${CERT_FILE} ${KEY_FILE} > /etc/ssl/private/pure-ftpd-cert.pem
    # -Y / --tls behavior
    # -Y 0 (default) disables SSL/TLS security mechanisms.
    # -Y 1 Accept both normal sessions and SSL/TLS ones.
    # -Y 2 refuses connections that aren't using SSL/TLS security mechanisms,
    #      including anonymous ones.
    # -Y 3 refuses connections that aren't using SSL/TLS security mechanisms,
    #      and refuse cleartext data channels as well.
    export ADDED_FLAGS="${ADDED_FLAGS} --tls=2"
fi

# if prod mode and file exists create pure-ftpd.pem
/run.sh -c 50 -C 10 -l puredb:/etc/pure-ftpd/pureftpd.pdb -E -j -R -P $PUBLICHOST -p 30000:30019