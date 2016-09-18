#!/bin/bash

while true; do
    # Clear retained messages if any.
    mqtt-simple -r -h mqtt.bitlair.nl -p "bitlair/flash" -m ''
    mqtt-simple --one -h mqtt.bitlair.nl -s "bitlair/flash" > /dev/null
    for i in {0..5}; do
        boblight-constant -p 2 ff0000 > /dev/null &
        sleep 0.05
        kill $!
        boblight-constant -p 2 0000ff > /dev/null &
        sleep 0.05
        kill $!
    done
done
