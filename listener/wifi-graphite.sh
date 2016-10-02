#!/bin/bash

GRAPHITE_HOST="192.168.88.14"
GRAPHITE_PORT="2003"

set -eu
set -o pipefail

ssids="spacenet bitlair-2ghz bitlair-5ghz eduroam djoamersfoort nieuwe-erven"

while true; do
    for ssid in $ssids; do
        online=`mqtt-simple -1 -h mqtt.bitlair.nl -s "bitlair/wifi/$ssid/online"`
        if [[ "$online" =~ ^[0-9]+$ ]]; then
            echo "bitlair.wifi.assoc.$ssid $online $(date +%s)" | nc "$GRAPHITE_HOST" "$GRAPHITE_PORT"
        fi
    done
    sleep 60
done
