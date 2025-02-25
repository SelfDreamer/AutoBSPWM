#!/bin/bash
servers=("bash-language-server" "lua-language-server" "basedpyright" "clangd" "rust-analyzer" "marksman")
for server in "${servers[@]}"; do
  nvim --headless -c "MasonInstall $server" +q # nvim --headless -c 'MasonInstall lua-language-server' +q & disown
done
