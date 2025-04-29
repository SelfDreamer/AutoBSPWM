#!/usr/bin/env bash

packages=$(/bin/cat /tmp/data.txt 2>/dev/null | grep -oP '\d+(?= packages)' 2>/dev/null)

if [[ -z $packages ]]; then
  packages=0
fi 

echo $packages
