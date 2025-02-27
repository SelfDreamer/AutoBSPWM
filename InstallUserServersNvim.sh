#!/bin/bash
servers=("bash-language-server" "lua-language-server" "basedpyright" "clangd" "rust-analyzer" "marksman")
export NVIM=$(find /opt/nvim/nvim*/bin/ -iname nvim -type f -executable | head -n 1)

for server in "${servers[@]}"; do
  $NVIM --headless -c "MasonInstall $server" -c 'qall' # nvim --headless -c 'MasonInstall lua-language-server' -c 'qall' 
done
