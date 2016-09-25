#!/bin/bash

CAM_NAME="$1"

if [ "$CAM_NAME" == "" ]; then
    echo "Usage: $0 <cam name>"
    exit
fi

set -eu
set -o pipefail

mqtt-simple --message-only -h mqtt.bitlair.nl -s "bitlair/cam/$CAM_NAME/viewers" |
    while read watchers; do
        if [ "$watchers" != "" ]; then
            plural=""
            if [ $(echo "$watchers" | wc -w) -gt 1 ]; then
                plural="s"
            fi
            irc-say "Camera viewer$plural: $watchers"
        fi
    done
