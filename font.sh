#!/bin/bash
readonly path="$(realpath $0 | rev | cut -d'/' -f2- | rev)"
cd "${path}" || return 1
source ./Colors
function ctrl_c(){
  echo -e "\n\n${bright_red}[!] Deteniendo script...${end}\n"
  exit 1
}

trap ctrl_c INT

echo -ne "\r${bright_cyan}[+]${bright_white} Introduce el nick que se vera reflejado en el fondo de pantalla: " && read -r NICK 

NICK="@${NICK:-$USER}"

INPUT_IMAGE="./wallpapers/HTB.jpg"

FONT_PATH="/usr/share/fonts/truetype/HackNerdFont-Regular.ttf"

OUTPUT_IMAGE="./wallpapers/Wallpaper.jpg"

convert "$INPUT_IMAGE" \
    -font "$FONT_PATH" \
    -pointsize 48 \
    -fill white \
    -gravity center \
    -annotate +0+140 "$NICK" \
    "$OUTPUT_IMAGE" &>/dev/null

echo -e "\n${bright_green}[✓]${bright_white} Imagen generada, nombre de usuario:${bright_magenta} $NICK${end}\n"
