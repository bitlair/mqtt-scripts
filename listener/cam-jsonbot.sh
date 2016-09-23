#!/bin/bash

CAM_NAME="space"

set -eu
set -o pipefail

mqtt-simple --message-only -h mqtt.bitlair.nl -s "bitlair/cam/$CAM_NAME/viewers" |
    while read watchers; do
        if [ "$watchers" != "" ]; then
            plural=""
            if [ $(echo "$watchers" | wc -w) -gt 1 ]; then
                plural="s"
            fi
            echo "NOTICE:Camera viewer$plural: $watchers" | jsb-udp
        fi
    done
