#!/bin/bash

# Publishes the number of cam watchers to the Bitlair MQTT server.

CAM_NAME="space"

set -eu
set -o pipefail

prev_watchers=""
while true; do
    watchers=`curl -s "https://portal.bitlair.nl/server-status" | sed -n 's/^.\+now\.mjpg?user=\(.\+\) HTTP.\+$/\1/p' | sort -u`
    if [ "$watchers" == "$prev_watchers" ]; then
        continue
    fi
    prev_watchers="$watchers"

    echo "$watchers" | wc -w       | mqtt-simple -r -h mqtt.bitlair.nl -p "bitlair/cam/$CAM_NAME"
    echo "$watchers" | tr '\n' ' ' | mqtt-simple -r -h mqtt.bitlair.nl -p "bitlair/cam/$CAM_NAME/viewers"

    sleep 1
done
