#!/bin/bash
set -e

if [[ ! -t 0 ]]; then
    /bin/bash /etc/banner.sh
fi

CERT_FILE="/etc/letsencrypt/real/fullchain1.pem"
KEY_FILE="/etc/letsencrypt/real/privkey1.pem"

if [[ -f ${CERT_FILE} ]] && [[ -f ${KEY_FILE} ]]; then
    print("Enabling SSL")
    cat ${CERT_FILE} ${KEY_FILE} > /etc/ssl/private/pure-ftpd-cert.pem
fi

# if prod mode and file exists create pure-ftpd.pem
/run.sh -c 50 -C 10 -l puredb:/etc/pure-ftpd/pureftpd.pdb -E -j -R -P $PUBLICHOST -p 30000:30019