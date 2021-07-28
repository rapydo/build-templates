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

    echo -e """[req]
default_bits = 4096
default_md = sha256
distinguished_name = req_distinguished_name
x509_extensions = v3_req
prompt = no
[req_distinguished_name]
C = XX
ST = XX
L = XXX
O = NoCompany
OU = Orgainizational_Unit
CN = ${ADDRESS}
[v3_req]
keyUsage = keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names
[alt_names]
IP.1 = ${ADDRESS}
""" > /tmp/config.ini
    openssl req -newkey rsa:4096 -nodes -sha256 -keyout ${REGISTRY_HTTP_TLS_KEY} -x509 -days 365 -config /tmp/config.ini -out ${REGISTRY_HTTP_TLS_CERTIFICATE} -subj '/CN=*/'
fi