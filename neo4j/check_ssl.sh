#!/bin/bash
set -e

# Mostly equal to check_ssl.sh script in rabbitmq build
function verify_ssl_files {

    if [[ ! -f "${1}" ]];
    then
        echo "SSL mandatory file not found: ${1}"
        echo "If you are already starting a proxy container, just wait for the installation of SSL certificates to be completed"
        echo "If you do not have a proxy container running on this host, you can create SSL certificates with the command: rapydo ssl --volatile"
        echo "This check will be automatically re-tried in a few seconds..."
        echo ""
        exit 1
    else
        echo "File ${1} verified"
    fi

}


if [[ "${NEO4J_dbms_ssl_policy_bolt_enabled}" == "True" ]];
then
    root="${NEO4J_dbms_ssl_policy_bolt_base__directory}"
    verify_ssl_files "${root}/${NEO4J_dbms_ssl_policy_bolt_public__certificate}"
    verify_ssl_files "${root}/${NEO4J_dbms_ssl_policy_bolt_private__key}"
fi

if [[ "${NEO4J_dbms_ssl_policy_https_enabled}" == "True" ]];
then
    root="${NEO4J_dbms_ssl_policy_https_base__directory}"
    verify_ssl_files "${root}/${NEO4J_dbms_ssl_policy_https_public__certificate}"
    verify_ssl_files "${root}/${NEO4J_dbms_ssl_policy_https_private__key}"
fi


# CVE-2021-44228 Mitigation, waiting for an updated version of neo4j (now 4.3.3)
# https://community.neo4j.com/t/log4j-cve-mitigation-for-neo4j/48856
echo "dbms.jvm.additional=-Dlog4j2.formatMsgNoLookups=true" >> conf/neo4j.conf