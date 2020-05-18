#!/bin/bash
set -e

CONF_DIR="/etc/nginx/sites-enabled"
TEMPLATE_DIR="/etc/nginx/sites-enabled-templates"

cp ${TEMPLATE_DIR}/maintenance.conf ${CONF_DIR}/

echo -e "\n\n"
echo "Maintenance server is up and waiting for connections. This server inform users that there is an ongoing maintenance"
echo "You can turn off this server after the maintenance is completed and before starting the normal stack"
echo -e "\n\n"

exec nginx -g 'daemon off;'
