#!/usr/bin/env bash
# Compare GPS_INPUT yaw (what we send) vs VFR_HUD heading (what EKF outputs).
# Shows both side by side to identify where delay occurs.
# Usage: ./heading_debug.sh [BLUEOS_HOST]

BLUEOS="${1:-192.168.1.248}"
BASE="http://${BLUEOS}/mavlink2rest/v1/mavlink/vehicles/1/components/1/messages"

echo "GPS_INPUT_yaw  vs  EKF_heading  (delta)"
echo "========================================="

while true; do
  GPS_YAW=$(curl -s "${BASE}/GPS_RAW_INT" | python3 -c "import sys,json; print(json.load(sys.stdin)['message'].get('yaw',0)/100.0)" 2>/dev/null)
  EKF_HDG=$(curl -s "${BASE}/VFR_HUD" | python3 -c "import sys,json; print(json.load(sys.stdin)['message'].get('heading',0))" 2>/dev/null)

  if [ -n "$GPS_YAW" ] && [ -n "$EKF_HDG" ]; then
    python3 -c "
g, e = $GPS_YAW, $EKF_HDG
d = g - e
if d > 180: d -= 360
if d < -180: d += 360
print(f'  GPS_yaw={g:6.1f}    EKF_hdg={e:3.0f}    delta={d:+.1f}')
"
  else
    echo "  (read error)"
  fi

  sleep 0.5
done
