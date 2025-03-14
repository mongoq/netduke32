#!/bin/bash

# Check if exactly one parameter is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 {enable|disable}"
    exit 1
fi

# Convert the parameter to uppercase
MODE=$(echo "$1" | tr '[:lower:]' '[:upper:]')

case "$MODE" in
    ENABLE)
        ./fritzbox-forward-port.sh ENABLE 192.168.0.3 22222
        ;;
    DISABLE)
        ./fritzbox-forward-port.sh DISABLE 192.168.0.3 22222
        ;;
    *)
        echo "Invalid parameter. Please use 'enable' or 'disable'."
        exit 1
        ;;
esac
