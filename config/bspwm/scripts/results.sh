#!/usr/bin/env bash
readonly PATH_ARCHIVE="${HOME}/.config/bin/updates.txt"

readonly packages="$(grep -oP '\d+(?= paquetes| packages)' "${PATH_ARCHIVE}" 2>/dev/null)"

echo "${packages:-0}"
