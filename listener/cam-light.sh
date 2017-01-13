#!/bin/bash

CAM_NAME="space"

set -eu
set -o pipefail

light_pid=""
mqtt-simple --message-only -h mqtt.bitlair.nl -s "bitlair/cam/$CAM_NAME" |
    while read num; do
        if [[ "$num" -gt 0 && -z "$light_pid" ]]; then
            perl -e 'for (0..12) { print "\x00\x00\x00" x 150 }' > /tmp/camera
            perl -e 'for (0..12) { print "\x00\xff\x00" x 150 }' > /tmp/camera
            perl -e 'for (0..12) { print "\x00\x00\x00" x 150 }' > /tmp/camera
            perl -e 'for (;;)    { print "\x00\xff\x00" x 150 }' > /tmp/camera &
            light_pid=$!
        elif [ ! -z "$light_pid" ]; then
            kill "$light_pid"
            light_pid=""
        fi
    done
