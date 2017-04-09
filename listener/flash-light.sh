#!/bin/bash

set -eu
set -o pipefail

while true; do
    sleep 1
    mqtt-simple -r -h mqtt.bitlair.nl -p bitlair/flash -m ''
    m=$(mqtt-simple --one -h mqtt.bitlair.nl -s "bitlair/flash")
    if [[ -z $m ]]; then
        continue
    fi
    for i in {0..2}; do
        perl -e 'for (0..3) { print "\xff\x00\x00" x 150 }' > /tmp/leds-messages
        perl -e 'for (0..3) { print "\x00\x00\xff" x 150 }' > /tmp/leds-messages
    done
done
