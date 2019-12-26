#!/bin/bash
set -eu

if [[ $RABBITMQ_ENABLE_MANAGEMENT_PLUGIN == 1 ]];
then
	rabbitmq-plugins enable rabbitmq_management
fi

if [[ $RABBITMQ_ENABLE_SHOVEL_PLUGIN == 1 ]];
then
	rabbitmq-plugins enable rabbitmq_shovel rabbitmq_shovel_management
fi
