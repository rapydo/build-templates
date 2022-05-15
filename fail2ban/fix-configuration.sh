#!/bin/bash

sed -i "s|#ignoreip =.*|ignoreip = 127.0.0.1/24 ${DOCKER_SUBNET}|g" /etc/fail2ban/jail.conf

echo "Enabling custom jail configuration"
cp /data/jail.d.available/jail.local /data/jail.d/jail.local

echo "Enabling backend jail and filters"
cp /data/filter.d.available/backend.conf filter.d/backend.conf
cp /data/jail.d.available/backend.local jail.d/backend.local

if [ "$MYSQL_ENABLED" == "1" ]; then
    echo "Enabling mysql jail and filters"
    cp /data/filter.d.available/mysql.conf filter.d/mysql.conf
    cp /data/jail.d.available/mysql.local jail.d/mysql.local
fi

if [ "$NEO4J_ENABLED" == "1" ]; then
    echo "Enabling neo4j jail and filters"
    cp /data/filter.d.available/neo4j.conf filter.d/neo4j.conf
    cp /data/jail.d.available/neo4j.local jail.d/neo4j.local
fi

if [ "$NGINX_ENABLED" == "1" ]; then
    echo "Enabling nginx jail and filters"
    cp /data/filter.d.available/nginx.conf filter.d/nginx.conf
    cp /data/jail.d.available/nginx.local jail.d/nginx.local
fi

if [ "$POSTGRES_ENABLED" == "1" ]; then
    echo "Enabling postgres jail and filters"
    cp /data/filter.d.available/postgres.conf filter.d/postgres.conf
    cp /data/jail.d.available/postgres.local jail.d/postgres.local
fi

if [ "$PUREFTP_ENABLED" == "1" ]; then
    echo "Enabling pureftpd jail and filters"
    cp /data/filter.d.available/pureftpd.conf filter.d/pureftpd.conf
    cp /data/jail.d.available/pureftpd.local jail.d/pureftpd.local
fi

if [ "$RABBITMQ_ENABLED" == "1" ]; then
    echo "Enabling rabbitmq jail and filters"
    cp /data/filter.d.available/rabbitmq.conf filter.d/rabbitmq.conf
    cp /data/jail.d.available/rabbitmq.local jail.d/rabbitmq.local
fi

if [ "$REDIS_ENABLED" == "1" ]; then
    echo "Enabling redis jail and filters"
    cp /data/filter.d.available/redis.conf filter.d/redis.conf
    cp /data/jail.d.available/redis.local jail.d/redis.local
fi


if [ "$FAIL2BAN_IPTABLES" == "nf_tables" ]; then
    echo "Enabling nftables-allport rules"
    sed -i "s|banaction =.*|banaction = nftables-allports|g" /data/jail.d/jail.local
    cp /data/action.d.available/nftables-common.local /data/action.d/
elif [ "$FAIL2BAN_IPTABLES" == "legacy" ]; then
    echo "Enabling iptables-allport rules"
    sed -i "s|banaction =.*|banaction = iptables-allports|g" /data/jail.d/jail.local
    cp /data/action.d.available/iptables-allports.local /data/action.d/
fi
