#!/bin/bash
set -e

CONF="/etc/rabbitmq/rabbitmq.conf"

echo "default_user = ${DEFAULT_USER}" >> ${CONF}
echo "default_pass = ${DEFAULT_PASS}" >> ${CONF}

if [[ ! -z $SSL_KEYFILE ]];
then
    echo "ssl_options.keyfile = ${SSL_KEYFILE}" >> ${CONF}
    echo "ssl_options.certfile = ${SSL_CERTFILE}" >> ${CONF}
    echo "ssl_options.cacertfile = ${SSL_CACERTFILE}" >> ${CONF}
    echo "ssl_options.fail_if_no_peer_cert = ${SSL_FAIL_IF_NO_PEER_CERT}" >> ${CONF}
    echo "management.ssl.keyfile = ${SSL_KEYFILE}" >> ${CONF}
    echo "management.ssl.certfile = ${SSL_CERTFILE}" >> ${CONF}
    echo "management.ssl.cacertfile = ${SSL_CACERTFILE}" >> ${CONF}
    echo "management.ssl.fail_if_no_peer_cert = ${SSL_FAIL_IF_NO_PEER_CERT}" >> ${CONF}
fi