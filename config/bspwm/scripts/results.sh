#!/usr/bin/env bash
readonly PATH_ARCHIVE="$HOME/.config/bin/updates.txt"
packages=$(grep "${PATH_ARCHIVE}" -oP '\d+(?= \S+)' 2>/dev/null)

echo "${packages:-0}"
