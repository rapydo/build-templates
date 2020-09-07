#!/bin/bash
set -e

echo "Converting TS Interfaces to JSON Schemas..."

ts-json-schema-generator -f /app/tsconfig.app.json -p /app/app/rapydo/app/types.ts -o /app/app/types.json

echo "Conversion completed"
