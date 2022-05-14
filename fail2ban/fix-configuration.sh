#!/bin/bash

sed -i "s|#ignoreip =.*|ignoreip = 127.0.0.1/24 ${DOCKER_SUBNET}|g" /etc/fail2ban/jail.conf

if [ "$FAIL2BAN_IPTABLES" == "nf_tables" ]; then
    sed -i "s|banaction =.*|banaction = nftables-allports|g" /etc/fail2ban/jail.conf
elif [ "$FAIL2BAN_IPTABLES" == "legacy" ]; then
    sed -i "s|banaction =.*|banaction = iptables-allports|g" /etc/fail2ban/jail.conf
fi

banaction = iptables-allports