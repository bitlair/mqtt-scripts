#!/bin/bash

set -eu
set -o pipefail

while true; do
    # Clear retained messages if any.
    mqtt-simple -r -h mqtt.bitlair.nl -p "bitlair/flash" -m ''
    mqtt-simple --one -h mqtt.bitlair.nl -s "bitlair/flash" > /dev/null
    for i in {0..2}; do
        perl -e 'for (0..3) { print "\xff\x00\x00" x 150 }' > /tmp/messages
        perl -e 'for (0..3) { print "\x00\xff\x00" x 150 }' > /tmp/messages
    done
done
