#!/usr/bin/env bash
kitty_url=$(curl -s https://api.github.com/repos/kovidgoyal/kitty/releases/latest | \
  jq -r '.assets[] | select(.name | endswith("x86_64.txz")) | .browser_download_url')

[[ -z "${kitty_url}" ]] && return 1 

dir="/opt/kitty"

[[ -d "${dir}" ]] && sudo rm -rf "${dir}"

sudo mkdir "${dir}"

wget "${kitty_url}" -O kitty_temp.txz && sudo mv kitty_temp.txz /opt/kitty && sudo 7z x /opt/kitty/kitty_temp.txz -o/opt/kitty && sudo tar -xf /opt/kitty/kitty*.tar -C /opt/kitty && sudo rm /opt/kitty/{kitty_temp.tar,kitty_temp.txz}
