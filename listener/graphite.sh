#!/bin/bash
export PATH=/usr/local/bin/:$PATH

#GRAPHITE_HOST="metrics.bitlair.nl"
GRAPHITE_HOST="192.168.88.14"
GRAPHITE_PORT="2003"


set -eu
set -o pipefail

mqtt-simple -h bitlair.nl -t "#" |
    while read line; do
        topic=$(echo "$line" | cut -d' ' -f1 | sed 's/\//./g' | tr '[:upper:]' '[:lower:]')
        value=$(echo "$line" | cut -s -d' ' -f2-)
        # Only relay numeric values.
        if [[ $value =~ ^-?[0-9]+\.?[0-9]*$ ]]; then
            echo "$topic $value $(date +%s)" | nc "$GRAPHITE_HOST" "$GRAPHITE_PORT"
        fi
    done
