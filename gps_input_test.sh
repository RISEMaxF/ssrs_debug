#!/usr/bin/env bash
# Test GPS_INPUT: sends 10 messages at 2Hz then checks if ArduPilot has a fix.
# Usage: ./gps_input_test.sh [BLUEOS_HOST] [GATEWAY_URL]

BLUEOS="${1:-192.168.1.248}"
GATEWAY="${2:-http://localhost:8080}"

echo "=== GPS_INPUT Test ==="
echo "BlueOS: ${BLUEOS}"
echo "Gateway: ${GATEWAY}"
echo ""

# Check current GPS state
echo "--- Before ---"
curl -s "http://${BLUEOS}/mavlink2rest/v1/mavlink/vehicles/1/components/1/messages/GPS_RAW_INT" \
  | python3 -c "import sys,json; d=json.load(sys.stdin)['message']; print(f\"fix={d['fix_type']} lat={d['lat']} lon={d['lon']} sats={d['satellites_visible']}\")" 2>/dev/null \
  || echo "(could not read GPS_RAW_INT)"
echo ""

# Send 10 GPS_INPUT messages via gateway
echo "--- Sending 10 GPS_INPUT messages via gateway ---"
for i in $(seq 1 10); do
  resp=$(curl -s -X POST "${GATEWAY}/command/gps_input" \
    -H 'Content-Type: application/json' \
    -d '{"lat": 57.6828, "lon": 11.9642, "alt": 5.0, "fix_type": 3, "satellites_visible": 10, "hdop": 0.9}')
  echo "  [$i] $resp"
  sleep 0.5
done
echo ""

# Send 10 GPS_INPUT messages directly to MAVLink2REST (bypass gateway)
echo "--- Sending 10 GPS_INPUT messages directly to MAVLink2REST ---"
for i in $(seq 1 10); do
  resp=$(curl -s -X POST "http://${BLUEOS}/mavlink2rest/v1/mavlink" \
    -H 'Content-Type: application/json' \
    -d '{
      "header": {"system_id": 255, "component_id": 0, "sequence": 0},
      "message": {
        "type": "GPS_INPUT",
        "time_usec": 0,
        "gps_id": 0,
        "ignore_flags": {"bits": 0},
        "time_week_ms": 0,
        "time_week": 0,
        "fix_type": 3,
        "lat": 576828000,
        "lon": 119642000,
        "alt": 5.0,
        "hdop": 0.9,
        "vdop": 1.0,
        "vn": 0.0,
        "ve": 0.0,
        "vd": 0.0,
        "speed_accuracy": 0.0,
        "horiz_accuracy": 1.0,
        "vert_accuracy": 1.0,
        "satellites_visible": 10,
        "yaw": 0
      }
    }')
  echo "  [$i] status=$?"
  sleep 0.5
done
echo ""

# Check GPS state after
echo "--- After ---"
curl -s "http://${BLUEOS}/mavlink2rest/v1/mavlink/vehicles/1/components/1/messages/GPS_RAW_INT" \
  | python3 -c "import sys,json; d=json.load(sys.stdin)['message']; print(f\"fix={d['fix_type']} lat={d['lat']} lon={d['lon']} sats={d['satellites_visible']}\")" 2>/dev/null \
  || echo "(could not read GPS_RAW_INT)"

echo ""
echo "If fix still shows NO_FIX, reboot the autopilot (GPS1_TYPE=14 requires reboot to take effect)."
