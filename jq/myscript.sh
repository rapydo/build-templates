#!/bin/bash

# set -e
# env

echo "List variables:"
echo "Batch dir: $BATCH_DIR_PATH"
echo
echo "List input:"
export fname='input.json'
echo $JSON_INPUT > $fname
jq -M -S . $fname

sleep 1234567890
