#!/usr/bin/env bash
TEXT="#ffffff"

readonly PATH_ARCHIVE="${HOME}/.config/bin/updates.txt"

readonly packages="$(grep -oP '\d+(?= paquetes| packages)' "${PATH_ARCHIVE}" 2>/dev/null)"

echo "%{F${TEXT}}${packages:-0}"
