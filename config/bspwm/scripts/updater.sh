#!/usr/bin/env bash
readonly ruta=$(realpath $0 | rev | cut -d'/' -f2- | rev) 
cd "${ruta}" || return 1 

source ./Colors
readonly PATH_ARCHIVE="/tmp/data.txt"
export SUDO_PROMPT="$(tput setaf 3)[${USER}]$(tput setaf 15) Enter your password for root: $(tput sgr0)"

function ctrl_c(){
  exit 1
}

trap ctrl_c INT

is_updated_system() {
  grep -oPq '\d+(?= paquetes| packages)' "${PATH_ARCHIVE}"
}

updater() {

  if sudo -v; then 
    tput civis
  fi

  sudo rm -f "${PATH_ARCHIVE}"
  touch "${PATH_ARCHIVE}"
  ( while true; do sudo -n true >/dev/null 2>&1; sleep 60; done ) &
  KEEP_ALIVE_PID=$!
  trap 'kill "$KEEP_ALIVE_PID"' EXIT

  sudo apt update 2>&1 | tee "$PATH_ARCHIVE" > /dev/null 
  

  if is_updated_system; then
    echo -e "\n${yellow}There are $updates_aviable updates available:${end}"
    echo -e "\n${blue}Regular updates:${end}\n"

    bright_white_awk=$(echo -e "${bright_white}")
    bright_green_awk=$(echo -e "${bright_green}")
    end_awk=$(echo -e "${end}")

    apt list --upgradable 2>/dev/null | grep -vi 'Listing...' | \
    awk -F'[ /\\[\\]]' -v white="$bright_white_awk" -v green="$bright_green_awk" -v end="$end_awk" \
    '{print white $1 end, green $8 " >> " $3 end}' | tee "${PATH_ARCHIVE}" 2>/dev/null

    echo -en "\n${bright_yellow}[+]${end}${bright_white} Program finished, press any key to exit${end} " && read -n1 key; echo 
  else
    echo -e "\n${bright_yellow}[*] No updates available${end}" && read -n1 key; echo
  fi
} 

function floating_window(){
  bspc node -t floating
  bspc node -z "right" "56" "34"
#  bspc node -v  400  0
  bspc node -v  0 -90
  bspc rule -r 'kitty'
}

main() {
  floating_window
  updater
  unset password
}

main
