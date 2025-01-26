#!/bin/bash
servers=("bash-language-server" "lua-language-server" "basedpyright" "clangd" "rust-analyzer")
for server in "${servers[@]}"; do
  nvim --headless -c "MasonInstall $server" +q &>/dev/null & disown # nvim --headless -c 'MasonInstall lua-language-server' +q & disown
done
