#!/bin/bash
set -e

export RABBITMQ_CTL_ERL_ARGS=""

rabbitmqctl eval 'ssl:clear_pem_cache().'

echo "PEM Cached cleared"

