#!/bin/bash
nvim_file=$(curl -s https://api.github.com/repos/neovim/neovim/releases/latest | jq -r '.assets[] | select(.name == "nvim-linux-x86_64.tar.gz") | .browser_download_url')
[[ -d "/opt/nvim" ]] && sudo rm -rf /opt/nvim
sudo mkdir -p /opt/nvim
wget $nvim_file && sudo mv nvim*.tar.gz /opt/nvim && sudo 7z x /opt/nvim/nvim*.gz -o/opt/nvim && sudo tar -xf /opt/nvim/nvim*.tar -C /opt/nvim && sudo rm -rf /opt/nvim/nvim-linux-x86_64.tar && sudo rm -rf /opt/nvim/nvim-linux-x86_64.tar.gz 
cat ~/.zshrc | sed "s|/opt/nvim.*bin|$(realpath /opt/nvim/nvim*64/bin)|" | sponge ~/.zshrc
sudo cat ~/.zshrc | sed "s|/opt/nvim.*bin|$(realpath /opt/nvim/nvim*64/bin)|" | sponge ~/.zshrc

