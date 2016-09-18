#!/bin/bash

CAM_NAME="space"

boblight_pid=""
mqtt-simple --message-only -h mqtt.bitlair.nl -s "bitlair/cam/$CAM_NAME" |
    while read num; do
        if [ "$num" -gt 0 ]; then
            boblight-constant -p 2 ff0000 > /dev/null &
            boblight_pid=$!
        else
            kill "$boblight_pid" 2> /dev/null
        fi
    done
