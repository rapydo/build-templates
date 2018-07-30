#!/bin/bash
set -e

echo "waiting for services"
#eval "$DEV_SU -c 'restapi wait'"
eval 'restapi wait'

echo "Requested command: $@"

# SLEEP=30
# echo "This request will be satisfied in ${SLEEP} seconds..."
# sleep $SLEEP

$@
exit 0
