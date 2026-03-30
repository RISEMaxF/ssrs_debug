#!/usr/bin/env bash
# Test GPS_INPUT directly to MAVLink2REST (bypass gateway), then check result.
# Usage: ./test_direct_gps.sh [BLUEOS_HOST]

BLUEOS="${1:-192.168.1.248}"

echo "Sending GPS_INPUT directly to MAVLink2REST (Malmo 55.6050, 13.0038)..."
curl -s -X POST "http://${BLUEOS}/mavlink2rest/v1/mavlink" \
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
      "lat": 556050000,
      "lon": 130038000,
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
  }'
echo ""

sleep 2

echo "Checking GPS_RAW_INT..."
curl -s "http://${BLUEOS}/mavlink2rest/v1/mavlink/vehicles/1/components/1/messages/GPS_RAW_INT"
echo ""
