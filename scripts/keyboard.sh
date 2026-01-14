#!/bin/bash

get_timezone_layout() {
    if ! command -v whois &> /dev/null; then
        echo "us" # Fallback si no hay whois
        return
    fi

    COUNTRY=$(whois $(curl -s ifconfig.me) | grep -iE "^country:" | tail -n 1 | awk '{print $NF}' | tr '[:lower:]' '[:upper:]')
    if [[ -z "$COUNTRY" ]]; then
        echo "us"
        return
    fi

    # Mapeo
    case "$COUNTRY" in
        PE|AR|MX|CO|CL|VE|BO|EC|UY|PY|CR|PA|DO|GT|HN|SV|NI)
            echo "latam"
            ;;
        ES)
            echo "es"
            ;;
        BR)
            echo "br"
            ;;
        GB)
            echo "gb"
            ;;
        *)
            echo "us"
            ;;
    esac

}

