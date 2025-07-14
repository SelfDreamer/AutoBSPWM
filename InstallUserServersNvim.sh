#!/bin/bash
servers=("bash-language-server" "lua-language-server" "basedpyright" "clangd" "rust-analyzer" "marksman" "intelephense")

for server in "${servers[@]}"; do
  /opt/nvim/bin/nvim --headless -c "MasonInstall $server" -c 'qall' # nvim --headless -c 'MasonInstall lua-language-server' -c 'qall' 
done
