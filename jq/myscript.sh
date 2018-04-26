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

file=$(jq -M -S -r .parameters.batch_number $fname)
ZIP_FILE="${file}.zip"
cd $BATCH_DIR_PATH
echo "unzipping: $ZIP_FILE"
unzip $file

# sleep 1234567890
exit 0
