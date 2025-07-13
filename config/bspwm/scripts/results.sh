#!/usr/bin/env bash
packages=$(grep /tmp/data.txt -oP '\d+(?= packages | paquetes)' 2>/dev/null)

echo "${packages:-0}"
