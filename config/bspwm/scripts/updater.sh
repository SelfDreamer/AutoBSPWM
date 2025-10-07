#!/usr/bin/env bash
readonly ruta=$(realpath $0 | rev | cut -d'/' -f2- | rev) 
cd "${ruta}" || return 1 

source ./Colors
readonly PATH_ARCHIVE="$HOME/.config/bin/updates.txt"
export SUDO_PROMPT="$(tput setaf 3)[${USER}]$(tput setaf 15) Enter your password for root: $(tput sgr0)"

function ctrl_c(){
  exit 1
}

trap ctrl_c INT

has_updates() {
  grep -oPq '\d+(?= paquetes| packages)' "${PATH_ARCHIVE}"
}
  
spinner_log() {
  tput civis 
  local msg="${1:-This is a message!}"
  local delay="${2:-0.2}"
  local pid="${3}"
  local values=('|' '/' '-' '\')
  local points=('.' '..' '...' '') 
  local len="${#values[@]}"
  (( ${#points[@]} < len )) && len="${#points[@]}" 

  local i=0
  while kill -0 "${pid}" &>/dev/null; do 
    local value="${values[i]}"
    local point="${points[i]}"
    echo -ne "\r\033[K${bright_cyan}[${value}]${end} ${msg}${bright_white}${point}${end}"
    sleep "${delay}"
    ((i=(i+1)%len))
  done

  echo -ne "\r\033[K"
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

  ( 
    sudo apt update 2>&1 | tee "$PATH_ARCHIVE" &> /dev/null 
    )  &

  PID=$!

  spinner_log "${bright_white}Checking updates${end}" "0.2" "${PID}"
  
  wait "${PID}"

  updates_aviable="$(grep -oP '\d+(?= paquetes| packages)' "${PATH_ARCHIVE}" 2>/dev/null)"

  if has_updates; then
    echo -e "\n${yellow}There are $updates_aviable updates available:${end}"
    echo -e "\n${blue}Regular updates:${end}\n"

    bright_white_awk=$(echo -e "${bright_white}")
    bright_green_awk=$(echo -e "${bright_green}")
    end_awk=$(echo -e "${end}")

    apt list --upgradable 2>/dev/null | grep -vP '^\S+\.\.\.$' | \
    awk -F'[ /\\[\\]]' -v white="$bright_white_awk" -v green="$bright_green_awk" -v end="$end_awk" \
    '{print white $1 end, green $8 " >> " $3 end}' 2>/dev/null 

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
}

main
