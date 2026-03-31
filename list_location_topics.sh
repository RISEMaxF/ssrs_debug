#!/bin/bash
# Show all location_fix topics being published on Zenoh (any entity)
docker run --rm --network host ghcr.io/rise-maritime/keelson-connector-blueos:v0.2.0 python3 -c "
import zenoh
s = zenoh.open(zenoh.Config())
def cb(sample):
    print(f'{sample.key_expr}')
s.declare_subscriber('rise/@v0/**/pubsub/location_fix/**', cb)
import time; time.sleep(3)
"
