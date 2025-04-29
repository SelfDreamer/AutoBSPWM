#!/usr/bin/env bash
ruta=$(realpath $0 | rev | cut -d'/' -f2- | rev) 
cd $ruta

source ./Colors
PATH_ARCHIVE="/tmp/data.txt"

function ctrl_c(){
  exit 1
}

trap ctrl_c INT

is_updated_system() {
  updates_aviable=$(grep -oP '\d+(?= packages)' "$PATH_ARCHIVE" 2>/dev/null)
  [[ -n "$updates_aviable" ]] && return 0 || return 1
}

get_passwd() {
  echo -ne "\n${bright_yellow}[$USER]${bright_white} Enter your password for root:${end} "
  read -r -s password

  timeout 1 echo "$password" | sudo -S whoami &>/dev/null 
  if [[ ! $? -eq 0 ]]; then
    tput civis 
    echo -e "\n${bright_red}[!] Incorrect password! Program finished, press any key to exit${end} " && read -n 1 key; echo 
    exit 1
  fi
}

run_with_sudo() {
  echo "$password" | sudo -S "$@" 2>/dev/null
  
}

updater() {
  run_with_sudo rm -f "$PATH_ARCHIVE"
  echo "$password" | sudo -S apt update 2>&1 | tee "$PATH_ARCHIVE" > /dev/null

  if is_updated_system; then
    echo -e "\n${yellow}There are $updates_aviable updates available:${end}"
    echo -e "\n${blue}Regular updates:${end}\n"

    bright_white_awk=$(echo -e "${bright_white}")
    bright_green_awk=$(echo -e "${bright_green}")
    end_awk=$(echo -e "${end}")

    apt list --upgradable 2>/dev/null | grep -vi 'Listing...' | \
    awk -F'[ /\\[\\]]' -v white="$bright_white_awk" -v green="$bright_green_awk" -v end="$end_awk" \
    '{print white $1 end, green $8 " >> " $3 end}' | tee "/tmp/avaiable_updates.txt" 2>/dev/null

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
  get_passwd
  tput civis 
  updater
  unset password
}

main

