#!/bin/bash

set -eu
set -o pipefail

mqtt-simple -h mqtt.bitlair.nl -s "bitlair/wifi/+" |
    while read event; do
        ssid=$(  echo "$event" | cut -d ' ' -f 1 | cut -d '/' -f 3)
        action=$(echo "$event" | cut -d ' ' -f 2)
        mac=$(   echo "$event" | cut -d ' ' -f 3)
        signal=$(echo "$event" | cut -d ' ' -f 4)

        dn=$(lookup-displayname "$mac")
        if [ "$dn" == "{}" ]; then
            continue
        fi
        displayname=$(echo "$dn" | jq -r '.displayname')
        device=$(echo "$dn" | jq -r '.device')

        if [ "$action" == "join" ]; then
            on="on"
            if [ "$signal" != "" ]; then
                sigstr="(signal: $signal dB SNR)"
            else
                sigstr=""
            fi
        elif [ "$action" == "part" ]; then
            on="from"
            sigstr=""
        else
            continue
        fi

        irc-say "$displayname's $device ${action}s $on $ssid"
    done
