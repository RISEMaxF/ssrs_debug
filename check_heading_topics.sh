#!/bin/bash
# Show all heading topics being published on Zenoh
python3 -c "
import zenoh
s = zenoh.open(zenoh.Config())
def cb(sample):
    print(f'GOT: {sample.key_expr}')
s.declare_subscriber('rise/@v0/ssrs18/pubsub/heading_true_north_deg/**', cb)
import time; time.sleep(5)
"
