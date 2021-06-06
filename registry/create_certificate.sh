#!/bin/ash
set -e

if [[ -z $REGISTRY_ADDRESS ]];
then
    echo "Invalid registry address"
    exit 1
fi

if [[ ! -f ${REGISTRY_HTTP_TLS_KEY} || ! -f ${REGISTRY_HTTP_TLS_CERTIFICATE} ]];
then
    # REGISTRY_ADDRESS == manager.host:port/
    # cut everything after the : => ADDRESS == manager.host
    ADDRESS=$(echo ${REGISTRY_ADDRESS%:*})

    # Beware! This only works if ADDRESS is an IP address.
    # Otherwise remove "IP:" in the subjectAltName
    echo -e "[ req ]\ndistinguished_name  = req_distinguished_name\n\n[ req_distinguished_name ]\ncountryName = XX\n\nbasicConstraints=critical,CA:true,pathlen:0\nsubjectAltName=IP:$ADDRESS" > /tmp/config.ini

    openssl req -newkey rsa:4096 -nodes -sha256 -keyout ${REGISTRY_HTTP_TLS_KEY} -x509 -days 365 -config /tmp/config.ini -out ${REGISTRY_HTTP_TLS_CERTIFICATE} -subj '/CN=*/'
fi