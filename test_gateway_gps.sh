#!/usr/bin/env bash
# Test GPS_INPUT via the gateway only, then check result.
# Usage: ./test_gateway_gps.sh [BLUEOS_HOST] [GATEWAY_URL]

BLUEOS="${1:-192.168.1.248}"
GATEWAY="${2:-http://localhost:8080}"

echo "Sending GPS_INPUT via gateway (Gothenburg 57.6828, 11.9642)..."
curl -s -X POST "${GATEWAY}/command/gps_input" \
  -H 'Content-Type: application/json' \
  -d '{"lat": 57.6828, "lon": 11.9642, "alt": 5.0, "fix_type": 3, "satellites_visible": 10, "hdop": 0.9}'
echo ""

sleep 2

echo "Checking GPS_RAW_INT..."
curl -s "http://${BLUEOS}/mavlink2rest/v1/mavlink/vehicles/1/components/1/messages/GPS_RAW_INT"
echo ""
