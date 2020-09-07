#!/bin/bash
set -e

ts-json-schema-generator -f /app/tsconfig.app.json -p /app/app/rapydo/app/types.ts -o /app/app/types.json
