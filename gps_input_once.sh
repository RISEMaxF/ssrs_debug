#!/usr/bin/env bash
# Send a single GPS_INPUT to the gateway.
# Usage: ./gps_input_once.sh [GATEWAY_URL]

GATEWAY="${1:-http://localhost:8080}"

curl -X POST "${GATEWAY}/command/gps_input" \
  -H 'Content-Type: application/json' \
  -d '{
    "lat": 57.6828,
    "lon": 11.9642,
    "alt": 5.0,
    "fix_type": 3,
    "satellites_visible": 10,
    "hdop": 0.9
  }'
echo
