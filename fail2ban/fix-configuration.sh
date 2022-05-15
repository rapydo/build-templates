#!/bin/bash

sed -i "s|#ignoreip =.*|ignoreip = 127.0.0.1/24 ${DOCKER_SUBNET}|g" /etc/fail2ban/jail.conf

if [ "$FAIL2BAN_IPTABLES" == "nf_tables" ]; then
    echo "Enabling nftables-allport rules"
    sed -i "s|banaction =.*|banaction = nftables-allports|g" /etc/fail2ban/jail.conf
    cp /data/action.d.available/nftables-common.local /data/action.d/
elif [ "$FAIL2BAN_IPTABLES" == "legacy" ]; then
    echo "Enabling iptables-allport rules"
    sed -i "s|banaction =.*|banaction = iptables-allports|g" /etc/fail2ban/jail.conf
    cp /data/action.d.available/nftables-common.local /data/action.d/
fi
