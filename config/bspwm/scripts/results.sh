#!/usr/bin/env bash
packages=$(/bin/cat /tmp/data.txt 2>/dev/null | grep -oP '\d+(?= packages | paquetes)' 2>/dev/null)

echo "${packages:-0}"
