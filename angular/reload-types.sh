#!/bin/bash
set -e

echo "Converting TS Interfaces to JSON Schemas..."

cat /app/app/rapydo/app/types.ts | grep -v 'from "@app/types"' > /tmp/types.ts
cat /app/app/custom/app/types.ts | grep -v 'from "@rapydo/types"' >> /tmp/types.ts

ts-json-schema-generator -f /app/tsconfig.app.json -p /tmp/types.ts -o /app/app/types.json

echo "Conversion completed"
