#!/bin/bash

PLAYER_NAME="space"

DATA_URL="https://music.bitlair.nl/trollibox/data/player/$PLAYER_NAME"

check_event() {
    event="$1"
    case "$event" in
        "playlist")
            curl -s "$DATA_URL/playlist" | jq -r '.tracks[.current] | .artist+" - "+.title' \
                | mqtt-simple -r -h mqtt.bitlair.nl -p "bitlair/music/$PLAYER_NAME/track"
            ;;
        "playstate")
            curl -s "$DATA_URL/playstate" | jq -r .playstate \
                | mqtt-simple -r -h mqtt.bitlair.nl -p "bitlair/music/$PLAYER_NAME/state"
            ;;
        "volume")
            curl -s "$DATA_URL/volume" | jq .volume \
                | mqtt-simple -r -h mqtt.bitlair.nl -p "bitlair/music/$PLAYER_NAME/volume"
            ;;
        *)
            ;;
    esac
}

check_event "playlist"
check_event "playstate"
check_event "volume"

curl --no-buffer --silent \
    -H "Connection: Upgrade" \
    -H "Upgrade: websocket" \
    -H "Host: music.bitlair.nl" \
    -H "Origin: https://music.bitlair.nl" \
    -H "Sec-WebSocket-Extensions: permessage-deflate; client_max_window_bits" \
    -H "Sec-WebSocket-Key: secretkeydonotsteal" \
    -H "Sec-WebSocket-Version: 13" \
    "$DATA_URL/listen" \
    | stdbuf -i0 -o0 -e0 tr -d [:cntrl:] \
    | stdbuf -i0 -o0 -e0 tr '\201' '\n' \
    | while read event; do
        check_event "$event"
    done
