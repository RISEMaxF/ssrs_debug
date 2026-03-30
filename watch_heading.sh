#!/usr/bin/env bash
# Continuously display ArduPilot heading in degrees (from VFR_HUD).
# Usage: ./watch_heading.sh [BLUEOS_HOST]

BLUEOS="${1:-192.168.1.248}"

while true; do
  curl -s "http://${BLUEOS}/mavlink2rest/v1/mavlink/vehicles/1/components/1/messages/VFR_HUD" \
    | python3 -c "import sys,json; d=json.load(sys.stdin)['message']; print(f\"heading={d['heading']}deg  groundspeed={d['groundspeed']:.1f}m/s  throttle={d['throttle']}%\")" 2>/dev/null \
    || echo "(no data)"
  sleep 1
done
