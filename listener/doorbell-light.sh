#!/bin/bash

set -eu
set -o pipefail

while true; do
    # Clear retained messages if any.
    mqtt-simple -r -h mqtt.bitlair.nl -p "bitlair/doorbell" -m ''
    sleep 1
    mqtt-simple --one -h mqtt.bitlair.nl -s "bitlair/doorbell" > /dev/null
    for i in {0..5}; do
        perl -e 'for (0..18) { print "\xff\xff\x00" x 150 }' > /tmp/leds-messages
        perl -e 'for (0..18) { print "\x00\x00\x00" x 150 }' > /tmp/leds-messages
    done
done
