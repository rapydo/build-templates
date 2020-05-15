#!/bin/bash
set -e

echo -e "\n\n"
echo "Maintenance server is up and waiting for connections. This server inform users that there is an ongoing maintenance"
echo "You can turn off this server after the maintenance is completed and before starting the normal stack"
echo -e "\n\n"

exec nginx -g 'daemon off;'
