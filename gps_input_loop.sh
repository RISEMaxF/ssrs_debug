#!/usr/bin/env bash
# Send GPS_INPUT continuously at 2 Hz. Ctrl-C to stop.
# ArduPilot needs continuous updates to maintain a GPS fix.
# Usage: ./gps_input_loop.sh [GATEWAY_URL]

GATEWAY="${1:-http://localhost:8080}"
INTERVAL=0.5  # seconds between sends (2 Hz)

LAT=57.6828    # Gothenburg harbor
LON=11.9642
ALT=5.0

echo "Sending GPS_INPUT to ${GATEWAY} at $(echo "1/${INTERVAL}" | bc) Hz"
echo "Position: ${LAT}, ${LON} — Ctrl-C to stop"

while true; do
  curl -s -X POST "${GATEWAY}/command/gps_input" \
    -H 'Content-Type: application/json' \
    -d "{
      \"lat\": ${LAT},
      \"lon\": ${LON},
      \"alt\": ${ALT},
      \"fix_type\": 3,
      \"satellites_visible\": 10,
      \"hdop\": 0.9
    }" > /dev/null
  sleep "${INTERVAL}"
done
