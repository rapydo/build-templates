#!/bin/bash
set -eu

if [[ ! -t 0 ]]; then
    /bin/ash /etc/banner.sh
fi

if [[ $RABBITMQ_ENABLE_SHOVEL_PLUGIN == 1 ]];
then
	rabbitmq-plugins enable rabbitmq_shovel rabbitmq_shovel_management
fi
