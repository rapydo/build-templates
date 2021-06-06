#!/bin/ash
set -e

if [[ -z $REGISTRY_ADDRESS ]];
then
    echo "Invalid registry address"
    exit 1
fi

# REGISTRY_ADDRESS == manager.host:port/
# cut everything after the : => subjectAltName == manager.host
subjectAltName=$(echo ${REGISTRY_ADDRESS%:*})

echo -e "basicConstraints=critical,CA:true,pathlen:0\nsubjectAltName=$subjectAltName" > /tmp/config.ini

openssl req -newkey rsa:4096 -nodes -sha256 -keyout ${REGISTRY_HTTP_TLS_KEY} -x509 -days 365 -config /tmp/config.ini -out ${REGISTRY_HTTP_TLS_CERTIFICATE}
