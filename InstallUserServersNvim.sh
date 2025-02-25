#!/bin/bash
servers=("bash-language-server" "lua-language-server" "basedpyright" "clangd" "rust-analyzer" "marksman")
if [[ $UID -eq 0 ]]; then
  export NVIM=$(find /opt/nvim/nvim*/bin/ -iname nvim -type f -executable | head -n 1)
    for server in "${servers[@]}"; do
      $NVIM --headless -c "MasonInstall $server" +q # nvim --headless -c 'MasonInstall lua-language-server' +q & disown
    done
fi

if [[ ! $UID -eq 0 ]]; then
  for server in "${servers[@]}"; do
    nvim --headless -c "MasonInstall $server" +q # nvim --headless -c 'MasonInstall lua-language-server' +q & disown
  done
fi
