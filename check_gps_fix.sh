#!/usr/bin/env bash
# Check if ArduPilot has a GPS fix
BLUEOS="${1:-192.168.1.248}"
curl -s "http://${BLUEOS}/mavlink2rest/v1/mavlink/vehicles/1/components/1/messages/GPS_RAW_INT"
