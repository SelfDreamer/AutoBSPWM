#!/usr/bin/env bash
nvim_file=$(curl -s https://api.github.com/repos/neovim/neovim/releases/latest | jq -r '.assets[] | select(.name == "nvim-linux-x86_64.tar.gz") | .browser_download_url')

sudo rm -rf /opt/nvim 2>/dev/null
sudo mkdir -p /opt/nvim/

[[ -z "${nvim_file}" ]] && return 1 

curl -L "${nvim_file}" | sudo tar -xzf - --strip-components=1 -C /opt/nvim
