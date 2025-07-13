#!/usr/bin/env bash

readonly ruta=$(realpath "${0}" | rev | cut -d'/' -f2- | rev)
readonly distro=$(lsb_release -d | grep -oP "Parrot|Kali")
cd "${ruta}" || exit 1

source ./Colors

PATH_ARCHIVE="/tmp/data.txt"

export SUDO_PROMPT="$(tput setaf 3)[${USER}]$(tput setaf 15) Introduce tu contraseña de root: $(tput sgr0)"

cleanup() {
  tput cnorm
  kill "$KEEP_ALIVE_PID" 2>/dev/null
  exit 1
}
trap cleanup INT EXIT

show_timestamp() {
  local secs=$1 msg=$2
  if (( secs < 60 )); then
    echo -e "${bright_green}[+]${bright_white} ${msg} en ${bright_magenta}${secs}${bright_white} segundos.${end}\n"
  else
    local mins=$(awk -v s="$secs" 'BEGIN { printf "%.2f", s/60 }')
    echo -e "${bright_green}[+]${bright_white} ${msg} en aprox. ${bright_magenta}${mins}${bright_white} minutos.${end}\n"
  fi
}

spinner() {
  local delay=0.2 pid=$1
  local chars=('|' '/' '-' "\\")
  tput civis
  while kill -0 "$pid" 2>/dev/null; do
    for c in "${chars[@]}"; do
      echo -ne "\r${bright_green}[${c}]${end} Buscando actualizaciones en ${bright_magenta}${distro}${end}"
      sleep "$delay"
    done
  done
  printf "\r\033[K"
  tput cnorm
}

has_updates() {
  grep -oPq '\\d+(?= paquetes| packages)' "$PATH_ARCHIVE"
}

updater() {
  SECONDS=0
  sudo rm -f "$PATH_ARCHIVE"
  sudo touch "$PATH_ARCHIVE"

  (
    sudo apt update 2>&1 | tee "$PATH_ARCHIVE" &>/dev/null
  ) &
  local pid=$!
  spinner "$pid"
  wait "$pid"

  if has_updates; then
    echo -e "\n${bright_yellow}[+] Hay actualizaciones disponibles.${end}\n"
    apt list --upgradable 2>/dev/null \
      | grep -v 'Listing...' \
      | awk -F'[ /\[\]]' \
          -v w="$bright_white" -v g="$bright_green" -v e="$end" \
          '{ print w $1 e, g $8 " >> " $3 e }' \
      | tee "${PATH_ARCHIVE}" &>/dev/null
  else
    echo -e "\n${bright_yellow}[+]${end}${bright_white} Estás al día, chaval ;)
"
  fi

  show_timestamp "$SECONDS" "Se actualizo la base de datos de tú sistema $distro"
  echo -e "\n${bright_yellow}[+]${bright_white} Fin del programa. Presiona cualquier tecla para salir...${end} "
  read -n1 -s
}

keep_sudo_alive() {
  while true; do
    sudo -n true 2>/dev/null || break
    sleep 60
  done
}

floating_window() {
  bspc node -t floating
  bspc node -z right 56 34
  bspc node -v 0 -90
}

main() {
  floating_window
  if sudo -v; then
    keep_sudo_alive &
    KEEP_ALIVE_PID=$!
    updater
  else
    echo -e "\n${bright_red}[!] Contraseña inválida para root.${end}\n"
    read -n1 -s
  fi
}

main

