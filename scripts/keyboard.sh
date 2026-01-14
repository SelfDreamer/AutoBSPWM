#!/bin/bash

get_timezone_layout() {
    if [ -f /etc/timezone ]; then
        TZ_FULL=$(cat /etc/timezone)
    else
        TZ_FULL=$(readlink /etc/localtime | sed 's|.*/zoneinfo/||')
    fi

    REGION=$(echo "$TZ_FULL" | cut -d'/' -f1)  # America
    CITY=$(echo "$TZ_FULL" | cut -d'/' -f2)    # Lima

    case "$REGION" in
        "America")
            case "$CITY" in
                Sao_Paulo|Bahia|Recife|Fortaleza|Belem|Manaus|Maceio)
                    echo "br" 
                    ;;
                New_York|Chicago|Los_Angeles|Toronto|Vancouver|Detroit)
                    echo "us"
                    ;;
                *)
                    echo "latam"
                    ;;
            esac
            ;;

        "Europe")
            case "$CITY" in
                Madrid|Ceuta|Canary)
                    echo "es"
                    ;;
                Lisbon|Madeira|Azores)
                    echo "pt"
                    ;;
                London|Belfast)
                    echo "gb"
                    ;;
                *)
                    echo "us"
                    ;;
            esac
            ;;

        *)
            echo "us"
            ;;
    esac
}

